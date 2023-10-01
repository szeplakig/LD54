extends Panel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("../Chest").status == "OPENED" and not get_node("../Chest").in_motion:
		visible = true
