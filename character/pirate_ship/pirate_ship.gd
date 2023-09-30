extends Node2D

enum TargettingStrategy {
	direct_shot,
	predictive_shot
}

enum ShootStrategy {
	single,
	spread,
	around
}

@onready var small_ship = preload("res://character/pirate_ship/assets/pirateship2.png")
@onready var medium_ship = preload("res://character/pirate_ship/assets/pirateship3.png")
@onready var large_ship = preload("res://character/pirate_ship/assets/pirateship1.png")

@export var selected_targetting_strategy: TargettingStrategy = TargettingStrategy.direct_shot
@export var selected_shoot_strategy: ShootStrategy = ShootStrategy.single
@export var shooting_interval: float = randf_range(3, 6)
@export var projectile_speed: float = 200
@export var projectile_damage: float = 1


@onready var projectile_scene: PackedScene = preload("res://object/projectile/projectile.tscn")
@onready var target: CharacterBody2D = get_node("/root/root/Player")
@onready var sprite: Sprite2D = $Sprite2D

var last_shoot_time: float = randf_range(0, shooting_interval - 2)

func setup():
	selected_shoot_strategy = [
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
	].pick_random()

func _ready():
	match selected_shoot_strategy:
		ShootStrategy.single:
			sprite.texture = small_ship
		ShootStrategy.spread:
			sprite.texture = medium_ship
		ShootStrategy.around:
			sprite.texture = large_ship

func _process(delta):
	last_shoot_time += delta
	if last_shoot_time >= shooting_interval:
		shoot()
		last_shoot_time = 0

func shoot():
	var shoot_direction = Vector2.ZERO
	shoot_direction = (target.global_position - global_position).normalized()
	
	match selected_shoot_strategy:
		ShootStrategy.single:
			spawn_projectile(shoot_direction)
		ShootStrategy.spread:
			# Shooting 3 projectiles as an example
			spawn_projectile(shoot_direction.rotated(deg_to_rad(-15)))
			spawn_projectile(shoot_direction)
			spawn_projectile(shoot_direction.rotated(deg_to_rad(15)))
		ShootStrategy.around:
			# Shooting projectiles in 360-degree spread
			for i in range(8):  # Spawning 8 projectiles evenly spaced around the ship
				spawn_projectile(shoot_direction.rotated(i * PI / 4 + last_shoot_time))

func spawn_projectile(direction: Vector2):
	var projectile: RigidBody2D = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.linear_velocity = direction * projectile_speed
	projectile.projectile_damage = projectile_damage
	projectile.rotation = direction.angle()
