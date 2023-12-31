extends Node2D

signal PlayerDamaged(max_health: float, current_health: float, damage_amount: float)
signal PlayerWin(score: int)
signal PlayerScore(score: int)


func player_damaged(max_health: float, current_health: float, damage_amount: float):
	PlayerDamaged.emit(max_health, current_health, damage_amount)
	if current_health == 0:
		game_over()
		pass


func game_over():
	Global.last_ending = "LOSE"
	get_tree().change_scene_to_file("res://main_menu.tscn")


func player_win(score: int):
	Global.score = score
	Global.last_ending = "WIN"
	if Global.is_tutorial:
		get_tree().change_scene_to_file("res://main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://leaderboard_menu.tscn")


func player_score(score: int):
	PlayerScore.emit(score)
