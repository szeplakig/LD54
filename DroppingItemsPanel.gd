extends Panel


var read = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not get_node("../Player").currentItem == null:
		visible = true
		get_node("../IItemCollectionPanel/").modulate.a = 0.5
		read = true
	if read and get_node("../Player").currentItem == null:
		modulate.a = 0.5
