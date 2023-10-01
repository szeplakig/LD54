extends Node2D

@onready var tilemap: TileMap = get_node("/root/root/Island")


func get_tile_at_position(object_global_position: Vector2):
	var object_local_position = tilemap.to_local(object_global_position)
	return tilemap.local_to_map(object_local_position)

func get_atlas_coord(object_global_position: Vector2):
	var tilemap_coords = get_tile_at_position(object_global_position)
	return tilemap.get_cell_atlas_coords(0, tilemap_coords)

func is_over_water_tile(object_global_position: Vector2):
	var atlas_coord = get_atlas_coord(object_global_position)
	return atlas_coord in tilemap.WATER_TILE_COORDS

func get_source_id_at_position(object_global_position: Vector2):
	var tilemap_coords = get_tile_at_position(object_global_position)
	return tilemap.get_cell_atlas_coords(0, tilemap_coords)
