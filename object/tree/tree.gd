extends Node2D

@onready var tree1 = preload("res://object/tree/assets/tree1.png")
@onready var tree2 = preload("res://object/tree/assets/tree2.png")
@onready var tree3 = preload("res://object/tree/assets/tree3.png")
@onready var treasure_scene: PackedScene = preload("res://item/plank/plank_item.tscn")
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Node2D = get_node("/root/root/Player")
@onready var wood_chop = $wood_chop

var drop_speed = 50
@export var drop_count_range_min: int = 1
@export var drop_count_range_max: int = 5
var drop_count_range = range(drop_count_range_min, drop_count_range_max)

var durability = 5
var default_offset = 0

var shake_amount = 0.2
var shake_duration = 0.1
var current_shake = 0


func _process(delta):
	if current_shake > 0:
		shake(delta, shake_amount)
		current_shake -= 1 * delta


func shake(delta, amount):
	if sprite:
		sprite.offset = (
			default_offset
			+ Vector2(
				range(-1.0, 1.0).pick_random() * amount, range(-1.0, 1.0).pick_random() * amount
			)
		)


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.set_texture([tree1, tree2, tree3].pick_random())
	default_offset = sprite.offset


func spawn_plank(direction: Vector2):
	var tree: RigidBody2D = treasure_scene.instantiate()
	get_parent().add_child(tree)
	tree.global_position = global_position + direction * 10
	tree.linear_velocity = direction * drop_speed


func _on_area_2d_input_event(viewport, event: InputEvent, shape_idx):
	if event.is_action_pressed("interact") and player.can_interact(self):
		interact()


func interact():
	if not wood_chop.playing:
		wood_chop.play()
	else:
		return false
	durability -= 1
	current_shake = 0.1
	if durability == 0:
		var drop_count = drop_count_range.pick_random()
		for i in range(drop_count):
			spawn_plank(Vector2.UP.rotated(i * PI / drop_count * 2))
			if sprite:
				sprite.queue_free()
				sprite = null
		return true


func _on_wood_chop_finished():
	if durability <= 0:
		queue_free()
