extends RigidBody2D

@onready var diamond = preload("res://item/treasure/assets/diamond.png")
@onready var emerald = preload("res://item/treasure/assets/emerald.png")
@onready var gold = preload("res://item/treasure/assets/gold.png")

@onready var collision = $CollisionShape2D
@onready var area = $Area2D
@export var repulsion_strength: float = 50.0
@onready var player: Node2D = get_node("/root/root/Player")

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
	$Sprite2D.texture = ([diamond, emerald, gold].pick_random())


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("interact") and player.can_interact(self):
		player.interact(self)
