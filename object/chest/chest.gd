extends TextureButton

var CLOSED = "CLOSED"
var OPENED = "OPENED"
var in_motion = false

var status = "CLOSED"

func _on_pressed():
	if not in_motion:
		if status == CLOSED:
			$AnimatedSprite2D.play("open")
			status = OPENED
		elif status == OPENED:
			$AnimatedSprite2D.play("close")
			status = CLOSED


func _on_animated_sprite_2d_animation_looped():
	if status == OPENED: $AnimatedSprite2D.play("opened")
	if status == CLOSED: $AnimatedSprite2D.play("closed")
	
