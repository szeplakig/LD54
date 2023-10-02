extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	sprite.frame = randi_range(0, 11)

