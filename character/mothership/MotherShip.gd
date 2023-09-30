extends Node2D

@onready var pirate_ship_scene : PackedScene = preload("res://character/pirate_ship/pirate_ship.tscn")
@onready var tilemap : TileMap = get_node("/root/root/Island")
@onready var player : Node2D = get_node("/root/root/Player")

@export var max_player_spawn_distance : float = 1000
@export var min_player_spawn_distance : float = 400
@export var min_ship_spawn_distance : float = 500

var time_since_last_spawn : float = 0.0
@export var spawn_interval : float = 10.0

func _ready():
	spawn_ship()

func _process(delta: float):
	time_since_last_spawn += delta
	if time_since_last_spawn >= spawn_interval:
		spawn_ship()
		time_since_last_spawn = 0.0

func spawn_ship():
	var current_ships : Array = get_children()
	var cells : Array[Vector2i] = tilemap.get_used_cells(0)
	cells.shuffle()
	current_ships.shuffle()
	
	var closest_distance = INF
	var selected_ship_cord = null

	for cell in cells:

		if not tilemap.is_deep_water(cell):
			continue
		var cell_world_pos = tilemap.to_global(tilemap.map_to_local(cell))
		var distance_to_player = cell_world_pos.distance_to(player.global_position)
		if distance_to_player < min_player_spawn_distance:
			continue
		if distance_to_player > max_player_spawn_distance:
			continue

		var too_close_to_ship = false
		for ship in current_ships:
			if cell_world_pos.distance_to(ship.global_position) <= min_ship_spawn_distance:
				too_close_to_ship = true
				break
		
		if not too_close_to_ship and distance_to_player < closest_distance:
			selected_ship_cord = cell_world_pos
			closest_distance = distance_to_player

	if closest_distance == INF:
		min_ship_spawn_distance *= 0.9
		print("No valid spawn location found.")
		return

	var new_ship = pirate_ship_scene.instantiate()
	new_ship.setup()
	new_ship.global_position = selected_ship_cord
	add_child(new_ship)
	new_ship.global_position = selected_ship_cord
