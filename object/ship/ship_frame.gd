extends TextureButton

var phase = 1

func _on_pressed():
	if (not get_node("../Player").currentItem == null) and "PlankItem" in get_node("../Player").currentItem.name:
		get_node("../Player").currentItem = null
		phase += 1
		if phase < 8:
			texture_normal = ImageTexture.create_from_image(Image.load_from_file("res://object/ship/assets/frame"+str(phase)+".png"))
		elif phase == 8:
			texture_normal = ImageTexture.create_from_image(Image.load_from_file("res://object/ship/assets/built.png"))
		else:
			pass
