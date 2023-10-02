extends Node2D

@onready var ship_phases = [
	preload("res://object/ship/assets/frame1.png"),
	preload("res://object/ship/assets/frame2.png"),
	preload("res://object/ship/assets/frame3.png"),
	preload("res://object/ship/assets/frame4.png"),
	preload("res://object/ship/assets/frame5.png"),
	preload("res://object/ship/assets/frame6.png"),
	preload("res://object/ship/assets/frame7.png"),
]
@onready var ship_built = preload("res://object/ship/assets/built.png")

@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Node2D = get_node("/root/root/Player")
@onready var slot: Node2D = $Slot
var phase = 0
var built_phase = 7


func _on_area_2d_input_event(viewport, event, shape_idx):
	if (
		event.is_action_pressed("interact")
		and player.can_interact(self)
		and player.currentItem != null
	):
		if player.currentItem.has_node("plank") and phase <= built_phase:
			interact()
		elif player.currentItem.has_node("treasure") and phase > built_phase:
			interact()


func interact():
	if (
		player.currentItem != null
		and player.currentItem.has_node("treasure")
		and phase > built_phase
	):
		player.add_score()
		player.currentItem.reparent(slot)
		player.currentItem.global_position = (
			slot.global_position + Vector2(randf_range(-10, 10), randf_range(-6, 6))
		)
		if player.currentItem.has_node("Interactable"):
			player.currentItem.get_node("Interactable").queue_free()
		player.currentItem = null

	else:
		player.spend_item()
		phase += 1
		if phase < 8 and phase >= 1:
			sprite.texture = ship_phases[phase - 1]
		elif phase == 8:
			sprite.texture = ship_built
