extends RigidBody2D

@export var stopped_speed: float = 80.0

@onready var GroundHitEffect: PackedScene = preload("res://object/projectile/ground_hit.tscn")
@onready var WaterHitEffects: PackedScene = preload("res://object/projectile/water_hit.tscn")
@onready var TargetHitEffects: PackedScene = preload("res://object/projectile/target_hit.tscn")

var projectile_damage: float = 0


func _physics_process(delta):
	if linear_velocity.length() < stopped_speed:
		queue_free()

func water_hit():
	queue_free()
	
func ground_hit():
	queue_free()
	
func target_hit():
	var effect = GroundHitEffect.instantiate()
	get_node("/root/root").add_child(effect)
	effect.global_position = global_position
	effect.emitting = true
	queue_free()
