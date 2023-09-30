extends Node2D


@onready var treasure_scene: PackedScene = preload("res://item/plank/plank_item.tscn")
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Node2D = get_node("/root/root/Player")

var drop_speed = 50
var drop_count_range = range(1,3)

var durability = 5


var shake_amount = 0.2
var shake_duration = 0.1
var current_shake = 0

func _process(delta):
	if current_shake > 0:
		shake(delta, shake_amount)
		current_shake -= 1 * delta
	
func shake(delta, amount):
	sprite.offset = Vector2(range(-1.0, 1.0).pick_random() * amount, range(-1.0, 1.0).pick_random() * amount)

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.set_texture(
		[
			ImageTexture.create_from_image(Image.load_from_file("res://object/tree/assets/tree1.png")),
			ImageTexture.create_from_image(Image.load_from_file("res://object/tree/assets/tree2.png")),
			ImageTexture.create_from_image(Image.load_from_file("res://object/tree/assets/tree3.png"))
		].pick_random()
	)


func spawn_plank(direction: Vector2):
	var tree: RigidBody2D = treasure_scene.instantiate(1)
	get_parent().add_child(tree)
	tree.global_position = global_position + direction * 10
	tree.linear_velocity = direction * drop_speed


func _on_area_2d_input_event(viewport, event: InputEvent, shape_idx):
	if event.is_action_pressed("interact") and player.can_interact(self):
		interact()

func interact():
	durability -= 1
	current_shake = 0.1
	if durability == 0:
		var drop_count = drop_count_range.pick_random()
		for i in range(drop_count):
			spawn_plank(Vector2.UP.rotated(i * PI / drop_count * 2))
		queue_free()
