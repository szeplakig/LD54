extends CharacterBody2D

@onready var root: Node2D = get_node("/root/root")
@onready var slot: Node2D = $Slot
var currentItem: Node2D = null
var overlapping_items: Array = []

@export var SPEED: float = 100
var motion = Vector2.ZERO

func _input(event: InputEvent):
	if event.is_action_pressed("interact"):
		interact(get_overlapping_item())
	elif event.is_action_pressed("drop"):
		drop()

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
	if item != null:
		if currentItem == null:
			pickup(item)
		else:
			swap(item)

func get_overlapping_item() -> Node2D:
	if overlapping_items.size() > 0:
		return overlapping_items[0]
	return null

func pickup(item: Node2D):
	currentItem = item
	currentItem.global_position = Vector2.ZERO
	currentItem.reparent(slot, false)
	currentItem.collision.disabled = true

func swap(item: Node2D):
	drop(item.global_position)
	pickup(item)


func drop(itemGlobalPosition=null):
	if currentItem != null:
		currentItem.collision.disabled = false
		currentItem.reparent(root)
		if itemGlobalPosition != null:
			currentItem.global_position = itemGlobalPosition
		currentItem = null

func damage(amount):
	print("damaged: ", amount)

func _on_area_2d_area_entered(area):
	if not (area is Node2D):
		return

	if area.get_parent().has_node("Interactable"):
		if area != currentItem and (currentItem == null or area != currentItem.area):
			overlapping_items.append(area.get_parent())
	elif area.get_parent().has_node("Projectile"):
		pass


func _on_area_2d_area_exited(area):
	overlapping_items.erase(area.get_parent())
