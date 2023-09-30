extends TextureButton

var CLOSED = "CLOSED"
var OPENED = "OPENED"
var empty = false

var in_motion = false

var status = "CLOSED"

@onready var  treasure_scene: PackedScene = preload("res://item/treasure/treasure_item.tscn")
var drop_speed = 200
var drop_count_range = range(2,10)

func _on_pressed():
	if not in_motion:
		in_motion = true		
		if status == CLOSED:
			$AnimatedSprite2D.play("open")
			status = OPENED
		elif status == OPENED:
			$AnimatedSprite2D.play("close")
			status = CLOSED
			


func _on_animated_sprite_2d_animation_looped():
	if in_motion:
		in_motion = false
		if status == OPENED:
			$AnimatedSprite2D.play("opened")
			if not empty:
				var drop_count = drop_count_range.pick_random()
				for i in range(drop_count):
					spawn_treasure(Vector2.UP.rotated(i * PI / drop_count*2))
				empty = true
		if status == CLOSED: $AnimatedSprite2D.play("closed")
	

func spawn_treasure(direction: Vector2):
	var treasure: RigidBody2D = treasure_scene.instantiate()
	get_parent().add_child(treasure)
	treasure.global_position = global_position+size/2
	treasure.linear_velocity = direction * drop_speed
