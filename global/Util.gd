extends Node


### the percent chance something happens
func chance(num):
	randomize()

	if randi() % 100 <= num:  return true
	else:                     return false

func capitalizeFirstLetter(_string) -> String:
	return _string.left(1).to_upper() + _string.right(_string.length()-1)


func return_damage_inflicted(hitbox_name:String,war_cry_active:bool,unstable_core_active:bool) -> int:
	var damage = return_hitbox_damage(hitbox_name)
	if war_cry_active:
		damage *= 1.2 # increase damage by 20%
	if unstable_core_active:
		damage += 30.0  # increase damage by 30
	return damage


func return_hitbox_damage(hitbox_name:String) -> int:
	return 10



### Setting collision layers
func return_hurtbox_layer(_team_color) -> int:
	match _team_color:
		"blue":
			return Constants.BLUE_TEAM_HURTBOX_LAYER
		"red":
			return Constants.RED_TEAM_HURTBOX_LAYER
		"white":
			return Constants.WHITE_TEAM_HURTBOX_LAYER
		_:
			printerr("INVALID HURTBOX DATA")
			return 0

func return_hitbox_layer(_team_color) -> int:
	match _team_color:
		"blue":
			return Constants.RED_TEAM_HURTBOX_LAYER + Constants.WHITE_TEAM_HURTBOX_LAYER
		"red":
			return Constants.BLUE_TEAM_HURTBOX_LAYER + Constants.WHITE_TEAM_HURTBOX_LAYER
		"white":
			return Constants.BLUE_TEAM_HURTBOX_LAYER + Constants.RED_TEAM_HURTBOX_LAYER 
		_:
			printerr("INVALID HITBOX DATA")
			return 0




### Validate and remove tile functions
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
