extends CharacterBody2D

@onready var utils: Node2D = get_node("/root/root/Utils")
@onready var event_bus: Node2D = get_node("/root/root/EventBus")

@onready var root: Node2D = get_node("/root/root")
@onready var ship: Node2D = get_node("/root/root/ShipFrame")

@onready var slot: Node2D = $Slot
var currentItem: Node2D = null
var overlapping_items: Array = []

@export var player_max_hp: float = 10
var player_hp: float = player_max_hp

var score: int = 0

@export var SPEED: float = 100
var motion = Vector2.ZERO

func _input(event: InputEvent):
	if event.is_action_pressed("interact"):
		interact(get_overlapping_item())
	elif event.is_action_pressed("drop"):
		drop()

# func _process(delta):
# 	print(utils.get_tile_at_position(global_position))

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
	move_and_collide(motion * delta)

func interact(item):
	if currentItem != null and currentItem.has_node("plank") and can_interact(ship):
		ship.interact()
		return
	
	if currentItem != null and currentItem.has_node("treasure") and can_interact(ship) and ship.phase > ship.built_phase:
		ship.interact()
		return

	if item != null:
		if currentItem == null:
			pickup(item)
		else:
			swap(item)

func get_overlapping_item() -> Node2D:
	if overlapping_items.size() > 0:
		var closest_item : Node2D = overlapping_items[0]
		var min_distance = self.position.distance_to(closest_item.position)
		
		for item in overlapping_items:
			var distance = self.position.distance_to(item.position)
			if distance < min_distance:
				min_distance = distance
				closest_item = item

		return closest_item

	return null


func pickup(item: Node2D):
	currentItem = item
	currentItem.reparent(slot, true)
	currentItem.position = Vector2.ZERO
	currentItem.collision.disabled = true

func swap(item: Node2D):
	drop(item.global_position)
	pickup(item)

func spend_item():
	if currentItem != null:
		currentItem.queue_free()
		drop()


func drop(itemGlobalPosition=null):
	if currentItem != null:
		currentItem.collision.disabled = false
		currentItem.reparent(root)
		if itemGlobalPosition != null:
			currentItem.global_position = itemGlobalPosition
		currentItem = null

func damage(amount):
	player_hp -= amount
	event_bus.player_damaged(player_max_hp, player_hp, amount)

func can_interact(other):
	return global_position.distance_to(other.global_position) < 75

func add_score():
	score += 1

func _on_area_2d_area_entered(area):
	if not (area is Node2D):
		return

	if area.get_parent().has_node("Interactable"):
		if area != currentItem and (currentItem == null or area != currentItem.area):
			overlapping_items.append(area.get_parent())
	if area.get_parent().has_node("Projectile"):
		damage(area.get_parent().projectile_damage)
		area.get_parent().target_hit()

func _on_area_2d_area_exited(area):
	overlapping_items.erase(area.get_parent())
