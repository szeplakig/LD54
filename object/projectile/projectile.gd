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
	queue_free()
	
func ground_hit():
	queue_free()
	
func target_hit():
	queue_free()
