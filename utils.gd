extends Node2D

@onready var tilemap: TileMap = get_node("/root/root/Island")


func get_tile_at_position(object_global_position: Vector2):
	var object_local_position = tilemap.to_local(object_global_position)
	var tilemap_coords = tilemap.local_to_map(object_local_position)

	if tilemap_coords != null:
		return tilemap_coords
	else:
		print("No tile found at position:", object_global_position)


func get_source_id_at_position(object_global_position: Vector2):
	var tilemap_coords = get_tile_at_position(object_global_position)
	var tile_source_id = tilemap.get_cell_atlas_coords(0, tilemap_coords)

	if tile_source_id != null:
		return tile_source_id
	else:
		print("No tile found at position:", object_global_position)
