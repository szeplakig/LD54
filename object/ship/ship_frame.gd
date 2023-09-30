extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Node2D = get_node("/root/root/Player")
var phase = 1


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("interact") and player.can_interact(self) and player.currentItem and "Plank" in player.currentItem.name:
		interact()

func interact():
	player.spend_item()
	phase += 1
	if phase < 8:
		sprite.texture = ImageTexture.create_from_image(Image.load_from_file("res://object/ship/assets/frame"+str(phase)+".png"))
	elif phase == 8:
		sprite.texture = ImageTexture.create_from_image(Image.load_from_file("res://object/ship/assets/built.png"))
	else:
		pass
