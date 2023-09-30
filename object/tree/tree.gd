extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	texture_normal = [
		ImageTexture.create_from_image(Image.load_from_file("res://object/tree/assets/tree1.png")),
		ImageTexture.create_from_image(Image.load_from_file("res://object/tree/assets/tree2.png")),
		ImageTexture.create_from_image(Image.load_from_file("res://object/tree/assets/tree3.png"))
		].pick_random()

