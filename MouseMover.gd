extends Node2D
# var mouse_sens= 300.0

# func _input(input_event: InputEvent):
# 	if input_event.is_action_pressed("interact"):
# 		var evt = InputEventMouseButton.new()
# 		evt.button_index = 0
# 		evt.position = get_viewport().get_mouse_position()
# 		evt.pressed = true
# 		get_tree().input_event(evt)
# 		evt.pressed = false
# 		get_tree().input_event(evt) 

# func _physics_process(delta):
# 	var direction: Vector2
# 	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
# 	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")


# 	if abs(direction.x) == 1 and abs(direction.y) == 1:
# 		direction = direction.normalized()

# 	var movement = mouse_sens * direction * delta
# 	if (movement):  
# 		get_viewport().warp_mouse(get_global_mouse_position()+movement) 
	
