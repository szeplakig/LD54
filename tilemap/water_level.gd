extends TileMap

const ISLAND_LVL_COORDS = [
		Vector2i(5,0),
		Vector2i(4,0),
		Vector2i(3,0),
		Vector2i(2,0),
		Vector2i(1,0),
		Vector2i(0,0),
	]
const WATER_TILE_COORDS = Vector2i(0,1)

@export var WATER_RISE_TICK = 5
@export var TILES_PER_TICK = 20
@export var WATER_NEIGHBOR_FLOOD_THRESHOLD = 2

var time_passed = 0

var current_water_lvl = 0
var tilemap = []


# Called when the node enters the scene tree for the first time.
func _ready():
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
	var player_pos = get_node("../Player").position

	for i in range(0,TILES_PER_TICK):
		var tiles = get_used_cells_by_id(0,0,ISLAND_LVL_COORDS[current_water_lvl])
		var rnd_ind = rng.randf_range(0,len(tiles))
		while !floodable(tiles[rnd_ind]):
			rnd_ind =  rng.randf_range(0,len(tiles))
		
		var remove_coord = tiles.pop_at(rnd_ind)
		var global_coord = to_global(map_to_local(remove_coord))
		
		if abs(player_pos[0] - global_coord[0]) <= 8 && abs(player_pos[1] - global_coord[1]) <= 8:
			game_over()
			
		set_cell(0,remove_coord,0,WATER_TILE_COORDS)
		if len(tiles) == 0 :
			current_water_lvl += 1
	pass

func game_over():
	print("GAME OVER")
	
func floodable(coord) -> bool:
	var neighbor_offsets = [
		Vector2i(1,1),
		Vector2i(1,0),
		Vector2i(1,-1),
		Vector2i(0,1),
		Vector2i(0,-1),
		Vector2i(-1,1),
		Vector2i(-1,0),
		Vector2i(-1,-1),
	]
	var water_neighbors = 0
	for offset in neighbor_offsets:
		if get_cell_atlas_coords(0,coord+offset) == WATER_TILE_COORDS :
			water_neighbors += 1
	
	return water_neighbors > WATER_NEIGHBOR_FLOOD_THRESHOLD
