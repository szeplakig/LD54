extends RigidBody2D

@export var stopped_speed: float = randf_range(60.0, 120.0)
@onready var utils: Node2D = get_node("/root/root/Utils")

@onready var GroundHitEffect: PackedScene = preload("res://object/projectile/ground_hit.tscn")
@onready var WaterHitEffects: PackedScene = preload("res://object/projectile/water_hit.tscn")
@onready var TargetHitEffects: PackedScene = preload("res://object/projectile/target_hit.tscn")

var projectile_damage: float = 0


func _physics_process(delta):
	if linear_velocity.length() < stopped_speed:
		if utils.is_over_water_tile(global_position):
			water_hit()
		else:
			ground_hit()
		queue_free()


func water_hit():
	var effect = WaterHitEffects.instantiate()
	get_node("/root/root").add_child(effect)
	effect.global_position = global_position
	effect.emitting = true
	queue_free()


func ground_hit():
	var effect = GroundHitEffect.instantiate()
	get_node("/root/root").add_child(effect)
	effect.global_position = global_position
	effect.emitting = true
	queue_free()


func target_hit():
	var effect = TargetHitEffects.instantiate()
	get_node("/root/root").add_child(effect)
	effect.global_position = global_position
	effect.emitting = true
	queue_free()
