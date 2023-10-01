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
var floodable_tiles = []
var update_floodable_tiles = true

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
	
	if (update_floodable_tiles && time_passed > 1):
		calculate_floodable_tiles()
		update_floodable_tiles = false
	
	if (time_passed >= WATER_RISE_TICK):
		time_passed = 0
		raise_water_lvl()
		update_floodable_tiles = true
	pass


func find_water_tile_distance(player_pos: Vector2i) -> float:
	var queue = []
	queue.push_back([player_pos, 0])  # [Position, Distance]

	var visited = {}
	visited[player_pos] = true

	while queue.size() > 0:
		var current = queue.pop_front()
		var current_pos = current[0]
		var current_distance = current[1]

		if is_water_tile(current_pos):
			return current_distance

		for offset in NEIGHBOR_OFFSETS:
			var neighbor_pos = current_pos + offset

			if neighbor_pos not in visited and get_cell_source_id(0, neighbor_pos) != -1:
				visited[neighbor_pos] = true
				queue.push_back([neighbor_pos, current_distance + 1])

	return -1


func is_water_tile(cell: Vector2i) -> bool:
	var atlas_coord = get_cell_atlas_coords(0, cell)
	return atlas_coord in WATER_TILE_COORDS


func raise_water_lvl():
	var local_player_pos = to_local(get_node("../Player").global_position)
	var player_pos = local_to_map(local_player_pos)
	closest_water_tile_distance = find_water_tile_distance(player_pos)
	print(closest_water_tile_distance)
	#if player_pos == remove_coord:
	#	game_over()
	var flooded = 0
	var old_flooded = 0

	while flooded < TILES_PER_TICK && current_water_lvl < len(ISLAND_LVL_COORDS):
		old_flooded = flooded
		print("AAA", flooded)
		print("current_water_lvl", current_water_lvl)
		print("len(ground_tiles[current_water_lvl])", len(ground_tiles[current_water_lvl]))
		var i = 0
		while i < len(ground_tiles[current_water_lvl]) && flooded < TILES_PER_TICK:
			if floodable_tiles.has(ground_tiles[current_water_lvl][i]):
				set_cell(0,ground_tiles[current_water_lvl][i],0,WATER_TILE_COORDS[0])
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
	# Get all tiles that are water, but not deep water
	var water_tiles = []
	for i in range(1,len(WATER_TILE_COORDS)):
		if get_cell_source_id(0,WATER_TILE_COORDS[i]) == 1:
			continue
		water_tiles += get_used_cells_by_id(0,0,WATER_TILE_COORDS[i])
	
	# Set their water neighbors to lightest
	var colored_tiles = []
	var all_ground_tiles = []
	for tiles in ground_tiles:
		all_ground_tiles += tiles
	
	for land_tile in all_ground_tiles:
		for offset in NEIGHBOR_OFFSETS:
			if get_cell_source_id(0,land_tile + offset):
				continue
			if get_cell_atlas_coords(0,land_tile + offset) == WATER_TILE_COORDS[len(WATER_TILE_COORDS) - 1] :
				set_cell(0,land_tile+offset,0,WATER_TILE_COORDS[0])
				colored_tiles.push_back(land_tile+offset)
	
	for i in range(0,len(WATER_TILE_COORDS)-1):
		# Set their water neighbors to lighter
		var new_colored_tiles = []
		for water_tile in colored_tiles:
			for offset in NEIGHBOR_OFFSETS:
				if get_cell_source_id(0,water_tile + offset):
					continue
				if get_cell_atlas_coords(0,water_tile+offset) == WATER_TILE_COORDS[len(WATER_TILE_COORDS) - 1]:
					set_cell(0,water_tile+offset,0,WATER_TILE_COORDS[i+1])
					new_colored_tiles.push_back(water_tile+offset)
		colored_tiles = new_colored_tiles

func is_deep_water(cell: Vector2i) -> bool:
	var atlas_coord = get_cell_atlas_coords(0, cell)
	return atlas_coord == WATER_TILE_COORDS[2]

func calculate_floodable_tiles():
	var all_ground_tiles = []
	for tiles in ground_tiles:
		all_ground_tiles += tiles
	
	var new_floodable_tiles = []
	for tile in all_ground_tiles:
		if (floodable(tile)):
			new_floodable_tiles.push_back(tile)
	
	floodable_tiles = new_floodable_tiles

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
