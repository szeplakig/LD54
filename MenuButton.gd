extends TextureButton


func _on_pressed():
	Global.last_ending = "NULL"
	get_tree().change_scene_to_file("res://main_menu.tscn")
