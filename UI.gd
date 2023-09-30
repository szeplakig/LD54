extends CanvasLayer

@onready var event_bus: Node2D = get_node("/root/root/EventBus")
@onready var hearts = [
	%Heart1,
	%Heart2,
	%Heart3,
	%Heart4,
	%Heart5,
]

@onready var score_text = $Control/Panel2/RichTextLabel

func _player_damaged_handler(max_health: float, current_health: float, damage_amount: float):
	_update_health(max_health,current_health)

func _player_score_handler(score: int):
	score_text.text = ' Gems: ' + str(score)

func _ready():
	event_bus.PlayerDamaged.connect(_player_damaged_handler)
	event_bus.PlayerScore.connect(_player_score_handler)

func _update_health(max,curr):
	for heart in hearts:
		heart.texture = load("res://ui/assets/heart_empty.png")
		
	var full_hearts = int(floor(curr / 2))
	for i in range(0,full_hearts):
		hearts[i].texture = load("res://ui/assets/heart_full.png")
	
	if int(curr) % 2 == 1:
		hearts[full_hearts].texture = load("res://ui/assets/heart_half.png")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
