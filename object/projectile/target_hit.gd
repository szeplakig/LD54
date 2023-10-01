extends CPUParticles2D

@export var delete_after: float = 5.0
var elapsed_time = 0.0


func _process(delta):
	elapsed_time += delta
	if elapsed_time >= delete_after:
		queue_free()
