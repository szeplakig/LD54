extends RigidBody2D

@export var stopped_speed: float = 80.0

@onready var GroundHitEffect
@onready var WaterHitEffects
@onready var TargetHitEffects

var projectile_damage: float = 0


func _physics_process(delta):
	if linear_velocity.length() < stopped_speed:
		queue_free()

func water_hit():
	pass
	
func ground_hit():
	pass
	
func target_hit():
	pass
