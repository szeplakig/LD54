extends Node2D

signal PlayerDamaged(max_health: float, current_health: float, damage_amount: float);


func player_damaged(max_health: float, current_health: float, damage_amount: float):
	PlayerDamaged.emit(max_health, current_health, damage_amount)
