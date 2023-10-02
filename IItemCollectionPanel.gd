extends Panel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not get_node("../Woods").get_child_count() == 6:
		visible = true
		get_node("../TreeChoppingPanel/").modulate.a = 0.5
