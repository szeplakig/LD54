extends Control

@onready var full_heart = preload("res://ui/assets/heart_full.png")
@onready var half_heart = preload("res://ui/assets/heart_half.png")
@onready var empty_heart = preload("res://ui/assets/heart_empty.png")

@onready var event_bus: Node2D = get_node("/root/root/EventBus")
@onready var hearts: Array[TextureRect] = [
	$MarginContainer/HBoxContainer/MarginContainer1/Heart1,
	$MarginContainer/HBoxContainer/MarginContainer2/Heart2,
	$MarginContainer/HBoxContainer/MarginContainer3/Heart3,
	$MarginContainer/HBoxContainer/MarginContainer4/Heart4,
	$MarginContainer/HBoxContainer/MarginContainer5/Heart5
]


func _player_damaged_handler(max_health: float, current_health: float, damage_amount: float):
	_update_health(max_health, current_health)


func _ready():
	event_bus.PlayerDamaged.connect(_player_damaged_handler)


func _update_health(max_hp, curr):
	for heart in hearts:
		heart.texture = empty_heart

	var full_hearts = int(floor(curr / 2))
	for i in range(0, full_hearts):
		hearts[i].texture = full_heart

	if int(curr) % 2 == 1:
		hearts[full_hearts].texture = half_heart


func _process(delta):
	pass
