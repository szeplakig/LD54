extends TextureButton


func _on_pressed():
	var player_position = get_node("./Player")
	var hook_position = hook.global_transform.origin
