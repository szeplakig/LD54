extends Panel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (
		get_node("../ShipFrame").phase == 8
		and get_node("../Chest").status == "OPENED"
		and not get_node("../Chest").in_motion
	):
		visible = true
	elif get_node("../ShipFrame").phase == 8:
		get_node("../ShipConstructionPanel/").modulate.a = 0.5


func _ready():
	Global.is_tutorial = true
