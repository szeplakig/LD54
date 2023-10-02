extends Node2D

@onready var cannon: AudioStreamPlayer2D = $cannon
@onready var treasure_scene: PackedScene = preload("res://item/plank/plank_item.tscn")
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Node2D = get_node("/root/root/Player")
@onready var wood_chop = $wood_chop

var drop_speed = 50
@export var drop_count_range_min: int = 10
@export var drop_count_range_max: int = 25
var drop_count_range = range(drop_count_range_min, drop_count_range_max)

var durability = 10
var default_offset = 0

var shake_amount = 0.3
var shake_duration = 0.1
var current_shake = 0

# From second script
enum TargettingStrategy { direct_shot, predictive_shot }

enum ShootStrategy { single, spread, around }

@onready var small_ship = preload("res://character/pirate_ship/assets/pirateship2.png")
@onready var medium_ship = preload("res://character/pirate_ship/assets/pirateship3.png")
@onready var large_ship = preload("res://character/pirate_ship/assets/pirateship1.png")

@export var selected_targetting_strategy: TargettingStrategy = TargettingStrategy.direct_shot
@export var selected_shoot_strategy: ShootStrategy = ShootStrategy.single
@export var shooting_interval: float = randf_range(3, 10)
@export var projectile_speed: float = 250
@export var projectile_damage: float = 1

@onready var projectile_scene: PackedScene = preload("res://object/projectile/projectile.tscn")
@onready var target: CharacterBody2D = get_node("/root/root/Player")

var last_shoot_time: float = randf_range(0, shooting_interval - 2)


func _ready():
	setup()
	match selected_shoot_strategy:
		ShootStrategy.single:
			sprite.texture = small_ship
			shooting_interval = randf_range(3, 5)
			durability = 7
		ShootStrategy.spread:
			sprite.texture = medium_ship
			shooting_interval = randf_range(5, 7)
			durability = 10
		ShootStrategy.around:
			sprite.texture = large_ship
			shooting_interval = randf_range(6, 10)
			durability = 15


func _process(delta):
	if current_shake > 0:
		shake(delta, shake_amount)
		current_shake -= 1 * delta

	last_shoot_time += delta
	if last_shoot_time >= shooting_interval:
		shoot()
		last_shoot_time = 0


func setup():
	selected_shoot_strategy = (
		[
			ShootStrategy.single,
			ShootStrategy.single,
			ShootStrategy.single,
			ShootStrategy.single,
			ShootStrategy.single,
			ShootStrategy.single,
			ShootStrategy.single,
			ShootStrategy.single,
			ShootStrategy.spread,
			ShootStrategy.spread,
			ShootStrategy.spread,
			ShootStrategy.spread,
			ShootStrategy.spread,
			ShootStrategy.around,
			ShootStrategy.around,
		]
		. pick_random()
	)


# Functions from the first script
func shake(delta, amount):
	if sprite:
		sprite.offset = (
			default_offset
			+ Vector2(
				range(-1.0, 1.0).pick_random() * amount, range(-1.0, 1.0).pick_random() * amount
			)
		)


func spawn_plank(direction: Vector2):
	var tree: RigidBody2D = treasure_scene.instantiate()
	get_parent().add_child(tree)
	tree.global_position = global_position + direction * 10
	tree.linear_velocity = direction * drop_speed


func _on_area_2d_input_event(viewport, event: InputEvent, shape_idx):
	if event.is_action_pressed("interact") and player.can_interact(self):
		interact()


func interact():
	if not wood_chop.playing:
		wood_chop.play()
	else:
		return false
	last_shoot_time *= 0.8
	durability -= 1
	current_shake = 0.2
	if durability == 0:
		var drop_count = drop_count_range.pick_random()
		for i in range(drop_count):
			spawn_plank(Vector2.UP.rotated(i * PI / drop_count * 2))
			if sprite:
				sprite.queue_free()
				sprite = null
		return true


# Functions from the second script
func shoot():
	if not target:
		return

	var shoot_direction = Vector2.ZERO
	shoot_direction = (target.global_position - global_position).normalized()

	cannon.play()
	match selected_shoot_strategy:
		ShootStrategy.single:
			spawn_projectile(shoot_direction)
		ShootStrategy.spread:
			spawn_projectile(shoot_direction.rotated(deg_to_rad(-15)))
			spawn_projectile(shoot_direction)
			spawn_projectile(shoot_direction.rotated(deg_to_rad(15)))
		ShootStrategy.around:
			for i in range(8):
				spawn_projectile(shoot_direction.rotated(i * PI / 4))


func spawn_projectile(direction: Vector2):
	var projectile: RigidBody2D = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.linear_velocity = direction * projectile_speed
	projectile.projectile_damage = projectile_damage
	projectile.rotation = direction.angle()


func _on_wood_chop_finished():
	if durability <= 0:
		queue_free()
