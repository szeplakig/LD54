extends Node2D

var game_over_scene = preload("res://game_over.tscn").instantiate()

signal PlayerDamaged(max_health: float, current_health: float, damage_amount: float);

func player_damaged(max_health: float, current_health: float, damage_amount: float):
	PlayerDamaged.emit(max_health, current_health, damage_amount)
	#if current_health == 0:
		#game_over()

func game_over():
	get_tree().root.add_child(game_over_scene)
