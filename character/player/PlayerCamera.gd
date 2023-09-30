extends Camera2D


var shake_amount = 1
var shake_duration = 0.1
var current_shake = 0

func _process(delta):
	position = get_local_mouse_position() / 4
	if current_shake > 0:
		shake(delta, shake_amount)
		current_shake -= 1 * delta
	
func shake(delta, amount):
	offset = Vector2(range(-1.0, 1.0).pick_random() * amount, range(-1.0, 1.0).pick_random() * amount)
