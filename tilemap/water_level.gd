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

@export var WATER_RISE_TICK = 2
@export var TILES_PER_TICK = 10
@export var WATER_NEIGHBOR_FLOOD_THRESHOLD = 3

var time_passed = 0

var current_water_lvl = 0
var tilemap = []


# Called when the node enters the scene tree for the first time.
func _ready():
	recolor_water()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	time_passed += delta
	if (time_passed >= WATER_RISE_TICK):
		time_passed = 0
		raise_water_lvl()
	pass

func raise_water_lvl():
	var rng = RandomNumberGenerator.new()
	var player_pos = local_to_map(to_local(get_node("../Player").global_position))

	for i in range(0,TILES_PER_TICK):
		if current_water_lvl >= len(ISLAND_LVL_COORDS):
			# The whole island is flooded
			# TODO: check if player is on the raft escaping
			game_over()
			break
			
		var tiles = get_used_cells_by_id(0, 0, ISLAND_LVL_COORDS[current_water_lvl])
		var rnd_ind = rng.randf_range(0,len(tiles))
		var depth = 0
		while !floodable(tiles[rnd_ind]) && depth < 30:
			rnd_ind =  rng.randf_range(0,len(tiles))
			depth += 1
		depth = 0
		
		var remove_coord = tiles.pop_at(rnd_ind)

		
		if player_pos == remove_coord:
			game_over()
			
		set_cell(0,remove_coord,0,WATER_TILE_COORDS[0])
		if len(tiles) == 0:
			current_water_lvl += 1
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
	# Get all tiles that are water
	var water_tiles = []
	for water_coord in WATER_TILE_COORDS:
		water_tiles += get_used_cells_by_id(0,0,water_coord)
	# Set them all to the darkest water
	for water_tile in water_tiles:
		set_cell(0,water_tile,0,WATER_TILE_COORDS[len(WATER_TILE_COORDS) - 1])
	# Get all land tiles of current lvl +  1 higher
	var land_tiles = []
	for land_coord in ISLAND_LVL_COORDS:
		land_tiles +=  get_used_cells_by_id(0,0,land_coord)
	
	# Set their water neighbors to lightest
	for land_tile in land_tiles:
		for offset in NEIGHBOR_OFFSETS:
			if get_cell_atlas_coords(0,land_tile + offset) == WATER_TILE_COORDS[len(WATER_TILE_COORDS) - 1]:
				set_cell(0,land_tile+offset,0,WATER_TILE_COORDS[0])
	
	for i in range(0,len(WATER_TILE_COORDS)-1):
		# Get all lightest water tiles
		water_tiles = get_used_cells_by_id(0,0,WATER_TILE_COORDS[i])
		# Set their water neighbors to lighter
		for water_tile in water_tiles:
			for offset in NEIGHBOR_OFFSETS:
				if get_cell_atlas_coords(0,water_tile+offset) == WATER_TILE_COORDS[len(WATER_TILE_COORDS) - 1]:
					set_cell(0,water_tile+offset,0,WATER_TILE_COORDS[i+1])


func is_deep_water(cell: Vector2i) -> bool:
	var atlas_coord = get_cell_atlas_coords(0, cell)
	return atlas_coord == WATER_TILE_COORDS[2]
