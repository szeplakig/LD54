extends TileMap

@onready var event_bus: Node2D = get_node("/root/root/EventBus")

const ISLAND_LVL_COORDS = [
	Vector2i(5, 0),
	Vector2i(4, 0),
	Vector2i(3, 0),
	Vector2i(2, 0),
	Vector2i(1, 0),
	Vector2i(0, 0),
]
const NEIGHBOR_OFFSETS = [
	Vector2i(1, 1),
	Vector2i(1, 0),
	Vector2i(1, -1),
	Vector2i(0, 1),
	Vector2i(0, -1),
	Vector2i(-1, 1),
	Vector2i(-1, 0),
	Vector2i(-1, -1),
]
const WATER_TILE_COORDS = [
	Vector2i(0, 1),
	Vector2i(1, 1),
	Vector2i(2, 1),
]

@export var WATER_RISE_TICK = 1
@export var TILES_PER_TICK = 30
@export var WATER_NEIGHBOR_FLOOD_THRESHOLD = 2

var time_passed = 0

var current_water_lvl = 0
var tilemap = []

var ground_tiles = []
var rng = RandomNumberGenerator.new()

var closest_water_tile_distance = null


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for coords in ISLAND_LVL_COORDS:
		var shuffled_coords = get_used_cells_by_id(0, 0, coords)
		shuffled_coords.shuffle()
		ground_tiles.push_back(shuffled_coords)

	recolor_water()
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	if time_passed >= WATER_RISE_TICK:
		time_passed = 0
		raise_water_lvl()
	pass


func find_water_tile_distance(player_pos: Vector2i):
	var queue = []
	queue.push_back([player_pos, 0])  # [Position, Distance]

	var visited = {}
	visited[player_pos] = true

	while queue.size() > 0:
		var current = queue.pop_front()
		var current_pos = current[0]
		var current_distance = current[1]

		if is_water_tile(current_pos):
			return to_global(map_to_local(current_pos)).distance_to(
				to_global(map_to_local(player_pos))
			)

		for offset in NEIGHBOR_OFFSETS:
			var neighbor_pos = current_pos + offset

			if neighbor_pos not in visited and get_cell_source_id(0, neighbor_pos) != -1:
				visited[neighbor_pos] = true
				queue.push_back([neighbor_pos, current_distance + 1])

	return null


func is_water_tile(cell: Vector2i) -> bool:
	var atlas_coord = get_cell_atlas_coords(0, cell)
	return atlas_coord in WATER_TILE_COORDS


func raise_water_lvl():
	var local_player_pos = to_local(get_node("../Player").global_position)
	var player_pos = local_to_map(local_player_pos)
	closest_water_tile_distance = find_water_tile_distance(player_pos)

	#if player_pos == remove_coord:
	#	game_over()
	var flooded = 0
	var old_flooded = 0

	while flooded < TILES_PER_TICK && current_water_lvl < len(ISLAND_LVL_COORDS):
		old_flooded = flooded
		var i = 0
		while i < len(ground_tiles[current_water_lvl]) && flooded < TILES_PER_TICK:
			if get_cell_source_id(0, ground_tiles[current_water_lvl][i]) == 1:
				print("cell source id == 1 : ", ground_tiles[current_water_lvl][i])
			if (
				floodable(ground_tiles[current_water_lvl][i])
				&& get_cell_source_id(0, ground_tiles[current_water_lvl][i]) != 1
			):
				set_cell(0, ground_tiles[current_water_lvl][i], 0, WATER_TILE_COORDS[0])
				flooded += 1

				if player_pos == ground_tiles[current_water_lvl][i]:
					game_over()
					return
				ground_tiles[current_water_lvl].remove_at(i)
			i += 1

		i = 0
		while i < len(ground_tiles[current_water_lvl]) && flooded < TILES_PER_TICK:
			if get_cell_source_id(0, ground_tiles[current_water_lvl][i]) == 1:
				print("cell source id == 1 : ", ground_tiles[current_water_lvl][i])
			if get_cell_source_id(0, ground_tiles[current_water_lvl][i]) != 1:
				set_cell(0, ground_tiles[current_water_lvl][i], 0, WATER_TILE_COORDS[0])
				flooded += 1

				if player_pos == ground_tiles[current_water_lvl][i]:
					game_over()
					return
				ground_tiles[current_water_lvl].remove_at(i)
			i += 1

		if len(ground_tiles[current_water_lvl]) == 0 || old_flooded == flooded:
			current_water_lvl += 1

	recolor_water()


func game_over():
	print("GAME OVER")
	return
	event_bus.game_over()


func floodable(coord) -> bool:
	if get_cell_source_id(0, coord) == 1:
		return false

	var water_neighbors = 0
	for offset in NEIGHBOR_OFFSETS:
		if get_cell_atlas_coords(0, coord + offset) == WATER_TILE_COORDS[0]:
			water_neighbors += 1

	return water_neighbors > WATER_NEIGHBOR_FLOOD_THRESHOLD


var deep_waters = {}


func recolor_water():
	# Get all tiles that are water
	var water_tiles = []
	for water_coord in WATER_TILE_COORDS:
		if get_cell_source_id(0, water_coord) == 1:
			continue
		water_tiles += get_used_cells_by_id(0, 0, water_coord)
	# Set them all to the darkest water
	for water_tile in water_tiles:
		if water_tile in deep_waters:
			continue
		set_cell(0, water_tile, 0, WATER_TILE_COORDS[len(WATER_TILE_COORDS) - 1])
	# Get all land tiles of current lvl +  1 higher
	var land_tiles = []
	for land_coord in ISLAND_LVL_COORDS:
		land_tiles += get_used_cells_by_id(0, 0, land_coord)

	# Set their water neighbors to lightest
	for land_tile in land_tiles:
		for offset in NEIGHBOR_OFFSETS:
			if (
				get_cell_atlas_coords(0, land_tile + offset)
				== WATER_TILE_COORDS[len(WATER_TILE_COORDS) - 1]
			):
				if get_cell_source_id(0, land_tile + offset) == 1:
					continue
				set_cell(0, land_tile + offset, 0, WATER_TILE_COORDS[0])

	for i in range(0, len(WATER_TILE_COORDS) - 1):
		# Get all lightest water tiles
		water_tiles = get_used_cells_by_id(0, 0, WATER_TILE_COORDS[i])
		# Set their water neighbors to lighter
		for water_tile in water_tiles:
			for offset in NEIGHBOR_OFFSETS:
				if (
					get_cell_atlas_coords(0, water_tile + offset)
					== WATER_TILE_COORDS[len(WATER_TILE_COORDS) - 1]
				):
					if get_cell_source_id(0, water_tile + offset) == 1:
						continue
					set_cell(0, water_tile + offset, 0, WATER_TILE_COORDS[i + 1])


func is_deep_water(cell: Vector2i) -> bool:
	var atlas_coord = get_cell_atlas_coords(0, cell)
	return atlas_coord == WATER_TILE_COORDS[2]


func set_plank(pos: Vector2i):
	for offset in [
		Vector2i(-1, -1),
		Vector2i(-1, 0),
		Vector2i(0, -1),
		Vector2i(0, 0),
		Vector2i(-1, 1),
		Vector2i(1, -1),
		Vector2i(1, 1),
		Vector2i(1, 0),
		Vector2i(0, 1)
	]:
		set_cell(0, pos + offset, 1, offset + Vector2i(1, 1))
