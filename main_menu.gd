extends Node


func _ready():
	Global.is_tutorial = false

	$MarginContainer/EndPanel/Credits.visible = false
	$MarginContainer/EndPanel/CreditsContent.visible = false
	$MarginContainer/EndPanel/YouWon.visible = false
	$MarginContainer/EndPanel/GameOver.visible = false

	if Global.last_ending == "NULL":
		$MarginContainer/EndPanel/Credits.visible = true
		$MarginContainer/EndPanel/CreditsContent.visible = true
	elif Global.last_ending == "WIN":
		$MarginContainer/EndPanel/YouWon.visible = true
	elif Global.last_ending == "LOSE":
		$MarginContainer/EndPanel/GameOver.visible = true
