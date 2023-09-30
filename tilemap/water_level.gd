extends TileMap

@onready var event_bus: Node2D = get_node("/root/root/EventBus")

const ISLAND_LVL_COORDS = [
		Vector2i(5,0),
		Vector2i(4,0),
		Vector2i(3,0),
		Vector2i(2,0),
		Vector2i(1,0),
		Vector2i(0,0),
	]
const NEIGHBOR_OFFSETS = [
		Vector2i(1,1),
		Vector2i(1,0),
		Vector2i(1,-1),
		Vector2i(0,1),
		Vector2i(0,-1),
		Vector2i(-1,1),
		Vector2i(-1,0),
		Vector2i(-1,-1),
	]
const WATER_TILE_COORDS = [
	Vector2i(0,1),
	Vector2i(1,1),
	Vector2i(2,1),
]

@export var WATER_RISE_TICK = 1
@export var TILES_PER_TICK = 20
@export var WATER_NEIGHBOR_FLOOD_THRESHOLD = 3

var time_passed = 0

var current_water_lvl = 0
var tilemap = []

var ground_tiles = []
var floodable_tiles = []
var update_floodable_tiles = true

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for coords in ISLAND_LVL_COORDS:
		var shuffled_coords = get_used_cells_by_id(0,0,coords)
		shuffled_coords.shuffle()
		ground_tiles.push_back(shuffled_coords)
	
	recolor_water()
	pass # Replace with function body.

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

func raise_water_lvl():
	var player_pos = local_to_map(to_local(get_node("../Player").global_position))
	#if player_pos == remove_coord:
	#	game_over()
	var flooded = 0;
	
	while flooded < TILES_PER_TICK && current_water_lvl < len(ISLAND_LVL_COORDS):
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
			set_cell(0,ground_tiles[current_water_lvl][i],0,WATER_TILE_COORDS[0])
			flooded += 1
		
			if player_pos == ground_tiles[current_water_lvl][i]:
				game_over()
				return
			ground_tiles[current_water_lvl].remove_at(i)
			i += 1
		
		if len(ground_tiles[current_water_lvl]) == 0:
			current_water_lvl += 1
#	for x in range(0,TILES_PER_TICK):
#		if current_water_lvl >= len(ISLAND_LVL_COORDS):
#			# The whole island is flooded
#			# TODO: check if player is on the raft escaping
#			game_over()
#			break
#
#		var i = 0
#		while i < len(tiles):
#			if floodable(tiles[i]):
#				floodables.push_back(tiles.pop_at(i))
#			i += 1
#
#		if len(floodables) == 0:
#			floodables = tiles
#
#		var rnd_ind = rng.randf_range(0,len(floodables))
#		print("rnd_ind:",rnd_ind)
#		print("floodables:",floodables)
#		var remove_coord = floodables.pop_at(rnd_ind)
#
#
#
#		set_cell(0,remove_coord,0,WATER_TILE_COORDS[0])
#
#		for offset in NEIGHBOR_OFFSETS:
#			if floodable(remove_coord+offset):
#				floodables.push_back(remove_coord+offset)
#
#		if len(tiles) == 0:
#			current_water_lvl += 1
#			tiles = get_used_cells_by_id(0, 0, ISLAND_LVL_COORDS[current_water_lvl])
	recolor_water()
	pass

func game_over():
	print("GAME OVER")
	return
	event_bus.game_over()
	
func floodable(coord) -> bool:
	var water_neighbors = 0
	for offset in NEIGHBOR_OFFSETS:
		if get_cell_atlas_coords(0,coord+offset) == WATER_TILE_COORDS[0] :
			water_neighbors += 1
	
	return water_neighbors > WATER_NEIGHBOR_FLOOD_THRESHOLD
	
func recolor_water():
	# Get all tiles that are water, but not deep water
	var water_tiles = []
	for i in range(1,len(WATER_TILE_COORDS)):
		water_tiles += get_used_cells_by_id(0,0,WATER_TILE_COORDS[i])
	
	# Set their water neighbors to lightest
	var colored_tiles = []
	var all_ground_tiles = []
	for tiles in ground_tiles:
		all_ground_tiles += tiles
	
	for land_tile in all_ground_tiles:
		for offset in NEIGHBOR_OFFSETS:
			if get_cell_atlas_coords(0,land_tile + offset) == WATER_TILE_COORDS[len(WATER_TILE_COORDS) - 1]:
				set_cell(0,land_tile+offset,0,WATER_TILE_COORDS[0])
				colored_tiles.push_back(land_tile+offset)
	
	for i in range(0,len(WATER_TILE_COORDS)-1):
		# Set their water neighbors to lighter
		var new_colored_tiles = []
		for water_tile in colored_tiles:
			for offset in NEIGHBOR_OFFSETS:
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
