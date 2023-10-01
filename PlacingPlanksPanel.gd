extends Panel


func _process(delta):
	if not get_node("../Player").currentItem == null:
		visible = true
