extends Node


func validate_tiles(location,dimensions) -> bool:
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			if not Server.world.valid_tiles.get_cell_atlas_coords(0,Vector2i(x-1,-y)+location) == Vector2i(0,0) or \
			Server.world.valid_tiles.local_to_map(Server.player_node.position) == Vector2i(-x,-y)+location or \
			Server.player_node.position.distance_to((location+Vector2i(-1,-1))*80) > Constants.MIN_PLACE_OBJECT_DISTANCE:
				return false
	return true


func remove_valid_tiles(location,dimensions) -> void:
	for x in range(dimensions.x):
		for y in range(dimensions.y):
			Server.world.valid_tiles.erase_cell(0,location+Vector2i(x-1,-y))
