extends Node2D

@onready var WaterHitEffects: PackedScene = preload("res://object/projectile/water_hit.tscn")
@onready var utils: Node2D = get_node("/root/root/Utils")

func water_hit():
	var effect = WaterHitEffects.instantiate()
	get_node("/root/root").add_child(effect)
	effect.global_position = global_position
	effect.emitting = true

func _process(delta):
	if utils.is_over_water_tile(global_position):
		water_hit()
		get_parent().queue_free()
