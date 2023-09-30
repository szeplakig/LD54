extends Control

@onready var event_bus: Node2D = get_node("/root/root/EventBus")

func _player_damaged_handler(max_health: float, current_health: float, damage_amount: float):
	print(max_health, " ", current_health, " ", damage_amount)


func _ready():
	event_bus.PlayerDamaged.connect(_player_damaged_handler)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
