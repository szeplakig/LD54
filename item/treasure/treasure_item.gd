extends RigidBody2D

@onready var collision = $CollisionShape2D
@onready var area = $Area2D
@export var repulsion_strength: float = 50.0
# Store the bodies that are currently overlapping with this one
var overlapping_bodies: Array = []

func repel_body(body: RigidBody2D):
	if body is RigidBody2D:
		var repulsion_direction = global_position - body.global_position
		repulsion_direction = repulsion_direction.normalized()
		apply_central_impulse(repulsion_direction * repulsion_strength)

func _physics_process(_delta):
	for body in overlapping_bodies:
		repel_body(body)

func _on_body_entered(body):
	if body is RigidBody2D:
		overlapping_bodies.append(body)

func _on_body_exited(body):
	if body in overlapping_bodies:
		overlapping_bodies.erase(body)

func _ready():
	$Sprite2D.texture = [
		ImageTexture.create_from_image(Image.load_from_file("res://item/treasure/assets/diamond.png")),
		ImageTexture.create_from_image(Image.load_from_file("res://item/treasure/assets/emerald.png")),
		ImageTexture.create_from_image(Image.load_from_file("res://item/treasure/assets/gold.png"))
		].pick_random()

