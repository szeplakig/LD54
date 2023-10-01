extends TextureButton




func _on_pressed():
	get_node("../TextEdit").editable = false
	var submitable_score = Global.score
	var submitable_username = get_node("../TextEdit").text
	# TODO send request
	visible = false
