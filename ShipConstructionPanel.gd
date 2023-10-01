extends Panel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not get_node("../Player").currentItem == null:
		visible = true
