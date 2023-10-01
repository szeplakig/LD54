extends Panel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("../ShipFrame").phase == 8:
		visible = true

func _ready():
		Global.is_tutorial = true
