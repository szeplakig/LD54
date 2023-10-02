extends CharacterBody2D

@onready var utils: Node2D = get_node("/root/root/Utils")
@onready var event_bus: Node2D = get_node("/root/root/EventBus")

@onready var root: Node2D = get_node("/root/root")
@onready var ship: Node2D = get_node("/root/root/ShipFrame")
@onready var tilemap: TileMap = get_node("/root/root/Island")

@onready var slot: Node2D = $Slot
var currentItem: Node2D = null
var overlapping_items: Array = []
var overlapping_harverstables: Array = []

@export var player_max_hp: float = 10
var player_hp: float = player_max_hp

var score: int = 0

@export var SPEED: float = 100
var motion = Vector2.ZERO


func _input(event: InputEvent):
	if event.is_action_pressed("interact"):
		interact(
			get_overlapping_item(overlapping_items), get_overlapping_item(overlapping_harverstables)
		)
	elif event.is_action_pressed("drop"):
		drop()
	elif event.is_action_pressed("finish") and can_interact(ship) and ship.phase > ship.built_phase:
		finish()
	elif event.is_action_pressed("build"):
		build()


func build():
	if currentItem != null and currentItem.has_node("plank"):
		var mouse_pos = get_global_mouse_position()
		if can_interact_pos(mouse_pos):
			var tile_pos = utils.get_tile_at_position(mouse_pos)
			if tile_pos != null:
				if not $drop.playing:
					$drop.play()
				tilemap.set_plank(tile_pos)
				spend_item()
				return
		var velocity_pos = global_position + velocity.normalized() * 35
		if can_interact_pos(velocity_pos):
			var tile_pos = utils.get_tile_at_position(velocity_pos)
			if tile_pos != null:
				if not $drop.playing:
					$drop.play()
				tilemap.set_plank(tile_pos)
				spend_item()
				return
		
		

func _ready():
	$AnimatedSprite2D.play("stand")


func finish():
	event_bus.player_win(score)


func _physics_process(delta):
	motion = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		motion.x += 1
	if Input.is_action_pressed("ui_left"):
		motion.x -= 1
	if Input.is_action_pressed("ui_down"):
		motion.y += 1
	if Input.is_action_pressed("ui_up"):
		motion.y -= 1

	motion = motion.normalized() * SPEED
	if not motion == Vector2.ZERO:
		$AnimatedSprite2D.play("move")
	else:
		$AnimatedSprite2D.play("stand")
	var collision = move_and_collide(motion * delta)
	velocity = motion
	if collision:
		move_and_slide()

	if get_global_mouse_position().x > global_position.x:
		$AnimatedSprite2D.scale.x = -4
	else:
		$AnimatedSprite2D.scale.x = 4


func interact(item, harvestable = null):
	if currentItem != null and currentItem.has_node("plank"):
		if can_interact(ship) and ship.phase <= ship.built_phase:
			ship.interact()
			return

	if (
		currentItem != null
		and currentItem.has_node("treasure")
		and currentItem.has_node("Interactable")
		and can_interact(ship)
		and ship.phase > ship.built_phase
	):
		ship.interact()
		return

	if harvestable != null and can_interact(harvestable):
		var should_remove = harvestable.interact()
		if should_remove:
			overlapping_harverstables.erase(harvestable)
		return

	if item != null and item.has_node("Interactable"):
		if currentItem == null:
			pickup(item)
		else:
			swap(item)


func get_overlapping_item(arr: Array) -> Node2D:
	for item in arr:
		if item == null:
			arr.erase(item)

	if arr.size() > 0:
		var closest_item: Node2D = arr[0]
		var min_distance = self.position.distance_to(closest_item.position)

		for item in arr:
			var distance = self.position.distance_to(item.position)
			if distance < min_distance:
				min_distance = distance
				closest_item = item
		return closest_item
	return null


func pickup(item: Node2D):
	if not $pickup.playing:
		$pickup.play()

	currentItem = item
	currentItem.reparent(slot, true)
	currentItem.position = Vector2.ZERO
	currentItem.rotation = 0
	currentItem.collision.disabled = true


func swap(item: Node2D):
	drop(item.global_position)
	pickup(item)


func spend_item():
	if currentItem != null:
		currentItem.queue_free()
		drop()


func drop(itemGlobalPosition = null):
	if currentItem != null:
		if not $drop.playing:
			$drop.play()
		currentItem.collision.disabled = false
		currentItem.reparent(root)
		if itemGlobalPosition != null:
			currentItem.global_position = itemGlobalPosition
		else:
			currentItem.global_position += Vector2(0, 15)
		if not currentItem.has_node("Interactable"):
			var interactable = Node2D.new()
			interactable.set_name("Interactable")
			currentItem.add_child(interactable)
		currentItem = null


func damage(amount):
	player_hp -= amount
	$Camera2D.current_shake = 0.1
	event_bus.player_damaged(player_max_hp, player_hp, amount)


func can_interact_pos(pos):
	return global_position.distance_to(pos) < 80


func can_interact(other):
	return can_interact_pos(other.global_position)


func add_score(_score=1):
	if not $drop.playing:
		$drop.play()
	score += _score
	event_bus.player_score(score)


func _on_area_2d_area_entered(area):
	if not (area is Node2D):
		return

	if area.get_parent().has_node("Interactable"):
		if (
			area.get_parent() != currentItem
			and (currentItem == null or area != currentItem.area)
			and not (area.get_parent() in overlapping_items)
		):
			overlapping_items.append(area.get_parent())

	if (
		area.get_parent().has_node("Harvestable")
		and not (area.get_parent() in overlapping_harverstables)
	):
		overlapping_harverstables.append(area.get_parent())


func _on_area_2d_area_exited(area):
	overlapping_items.erase(area.get_parent())
	overlapping_harverstables.erase(area.get_parent())


func _on_hitbox_area_entered(area):
	if not (area is Node2D):
		return
	if area.get_parent().has_node("Projectile"):
		damage(area.get_parent().projectile_damage)
		area.get_parent().target_hit()
