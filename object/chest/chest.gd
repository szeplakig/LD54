extends Node2D

var CLOSED = "CLOSED"
var OPENED = "OPENED"
var empty = false

var in_motion = false

var status = "CLOSED"

@onready var player: Node2D = get_node("/root/root/Player")
@onready var sprite = $AnimatedSprite2D

@onready var  treasure_scene: PackedScene = preload("res://item/treasure/treasure_item.tscn")
var drop_speed = 50
var drop_count_range = range(1,10)

func _on_animated_sprite_2d_animation_looped():
	if in_motion:
		in_motion = false
		if status == OPENED:
			sprite.play("opened")
			if not empty:
				var drop_count = drop_count_range.pick_random()
				for i in range(drop_count):
					spawn_treasure(Vector2.UP.rotated(i * PI / drop_count*2))
				empty = true
		if status == CLOSED: sprite.play("closed")
	

func spawn_treasure(direction: Vector2):
	var treasure: RigidBody2D = treasure_scene.instantiate()
	get_parent().add_child(treasure)
	treasure.global_position = global_position + direction * 15
	treasure.linear_velocity = direction * drop_speed


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("interact") and player.can_interact(self):
		interact()

func interact():
	if not in_motion:
		in_motion = true		
		if status == CLOSED:
			sprite.play("open")
			status = OPENED
		elif status == OPENED:
			sprite.play("close")
			status = CLOSED
