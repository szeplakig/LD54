extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.is_tutorial = false
	if Global.last_ending == "NULL":
		$EndPanel.visible = false
	elif Global.last_ending == "WIN":
		$EndPanel/YouWon.visible = true
	elif Global.last_ending == "LOSE":
		$EndPanel/GameOver.visible = true
