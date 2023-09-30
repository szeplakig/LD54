extends Control

@onready var event_bus: Node2D = get_node("/root/root/EventBus")

# Called when the node enters the scene tree for the first time.
func _ready():
	event_bus.connect("PlayerWin",_on_player_win)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_score(value):
	%GemsLabel.text = str("You escaped with ",value," gems")

func set_show(value: bool):
	%GameOverCanvas.visible = value

func _on_player_win(score:int):
	set_score(score)
	set_show(true)
