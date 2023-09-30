extends Node2D

signal PlayerDamaged(max_health: float, current_health: float, damage_amount: float);

func player_damaged(max_health: float, current_health: float, damage_amount: float):
	PlayerDamaged.emit(max_health, current_health, damage_amount)
	if current_health == 0:
		return
		game_over()

func game_over():
	return
	get_tree().change_scene_to_file("res://game_over.tscn")
