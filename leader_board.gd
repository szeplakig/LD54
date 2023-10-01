extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	$ScorePanel/Label.text = str(Global.score)

