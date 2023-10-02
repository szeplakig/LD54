extends Node


func _ready():
	if OS.has_feature("web"):
		$MarginContainer2/VBoxContainer/HBoxContainer/MarginContainer3.visible = false

	Global.is_tutorial = false

	$MarginContainer2/VBoxContainer/MarginContainer2/EndPanel/Credits.visible = false
	$MarginContainer2/VBoxContainer/MarginContainer2/EndPanel/CreditsContent.visible = false
	$MarginContainer2/VBoxContainer/MarginContainer2/EndPanel/YouWon.visible = false
	$MarginContainer2/VBoxContainer/MarginContainer2/EndPanel/GameOver.visible = false

	if Global.last_ending == "NULL":
		$MarginContainer2/VBoxContainer/MarginContainer2/EndPanel/Credits.visible = true
		$MarginContainer2/VBoxContainer/MarginContainer2/EndPanel/CreditsContent.visible = true
	elif Global.last_ending == "WIN":
		$MarginContainer2/VBoxContainer/MarginContainer2/EndPanel/YouWon.visible = true
	elif Global.last_ending == "LOSE":
		$MarginContainer2/VBoxContainer/MarginContainer2/EndPanel/GameOver.visible = true
