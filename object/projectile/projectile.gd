extends RigidBody2D

@export var stopped_speed: float = 3.0


func _physics_process(delta):
	if linear_velocity.length() < stopped_speed:
		queue_free()
