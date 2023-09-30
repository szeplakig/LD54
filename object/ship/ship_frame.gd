extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Node2D = get_node("/root/root/Player")
@onready var slot: Node2D = $Slot
var phase = 7
var built_phase = 7


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("interact") and player.can_interact(self) and player.currentItem != null:
		if player.currentItem.has_node("plank"):
			interact()
		elif player.currentItem.has_node("treasure") and phase > built_phase:
			interact()

func interact():
	if player.currentItem != null and player.currentItem.has_node("treasure") and phase > built_phase:
		player.add_score()
		player.currentItem.reparent(slot)
		player.currentItem.global_position = slot.global_position + Vector2(randf_range(-10, 10), randf_range(-6, 6))
		player.currentItem.get_node("Interactable").queue_free()
		player.currentItem = null
		

	else:
		player.spend_item()
		phase += 1
		if phase < 8:
			sprite.texture = ImageTexture.create_from_image(Image.load_from_file("res://object/ship/assets/frame"+str(phase)+".png"))
		elif phase == 8:
			sprite.texture = ImageTexture.create_from_image(Image.load_from_file("res://object/ship/assets/built.png"))
