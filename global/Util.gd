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


func return_percentage_health_increase(percentage_to_heal,max_health) -> int:
	return max_health / percentage_to_heal


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



func return_abbreviated_character_name(_char_name):
	match _char_name:
		"technomancer":
			return "tech"
		"valkyrie":
			return "val"
		"steelthorn":
			return "Steel"
		"magmaul":
			return "Magmaul"
		"mariselle":
			return "Mari"
		_:
			return _char_name


### Damage inflicted
func return_health_change(character,type) -> int:
#	if character == "valkyrie" and type == "ultimate":
#		return -60
	if character == "ghoul" or character == "ghoul2":
		return -Constants.ad_data[character][type]["damage"]
	elif character == "tower" or character == "unstable core":
		return -Constants.structure_data[character][type]["damage"]
	elif character == "tree" or character == "golem":
		return -Constants.beast_data[character][type]["damage"]
	return -Constants.character_data[character][type]["damage"]


func destructable_projectile(character,type) -> bool:
	if type == "ultra" or character == "magmaul" or character == "valkyrie" or character == "ghoul" or character == "tree":
		return false
	return true



### Detect enemy nodes
func get_nearest_aggro_target(_detect_enemy_node): 
	var enemy_node
	var max_distance_to_check = 100000.0
	var _pos = _detect_enemy_node.global_position
	var _enemy_nodes = _detect_enemy_node.get_overlapping_bodies()
	if _enemy_nodes.size() == 0:
		return null
	else:
		for node in _enemy_nodes:
			var distance_to_enemy = _pos.distance_to(node.global_position)
			if distance_to_enemy < max_distance_to_check and node.character_stats.aggro_mode:
				max_distance_to_check = distance_to_enemy
				enemy_node = node
		return enemy_node

func get_nearest_target(_detect_enemy_node): 
	var enemy_node
	var max_distance_to_check = 100000.0
	var _pos = _detect_enemy_node.global_position
	var _enemy_nodes = _detect_enemy_node.get_overlapping_bodies()
	if _enemy_nodes.size() == 0:
		return null
	else:
		for node in _enemy_nodes:
			var distance_to_enemy = _pos.distance_to(node.global_position)
			if distance_to_enemy < max_distance_to_check:
				max_distance_to_check = distance_to_enemy
				enemy_node = node
		return enemy_node
		
		
func get_nearest_targets(_detect_enemy_node): 
	var targets
	var enemy_node
	var max_distance_to_check = 100000.0
	var _pos = _detect_enemy_node.global_position
	var _enemy_nodes = _detect_enemy_node.get_overlapping_bodies()
	if _enemy_nodes.size() == 0:
		return null
	else:
		for node in _enemy_nodes:
			var distance_to_enemy = _pos.distance_to(node.global_position)
			if distance_to_enemy < max_distance_to_check:
				max_distance_to_check = distance_to_enemy
				enemy_node = node
		return enemy_node

func get_lowest_health_target(_detect_enemy_node):
	var enemy_node
	var max_health_to_check = 100000.0
	var _pos = _detect_enemy_node.global_position
	var _enemy_nodes = _detect_enemy_node.get_overlapping_bodies()
	if _enemy_nodes.size() == 0:
		return null
	else:
		for node in _enemy_nodes:
			var health_of_enemy = node.get_node("hurtbox").health
			if health_of_enemy < max_health_to_check:
				max_health_to_check = health_of_enemy
				enemy_node = node
		return enemy_node

func return_random_idle_position(_spawn_pos) -> Vector2:
	var random_vec = Vector2(randf_range(100,400),randf_range(100,400))
	if chance(50):
		random_vec.x *= -1
	if chance(50):
		random_vec.y *= -1
	return random_vec + _spawn_pos


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
			
			
			
### Set character attributes

func is_character_ad(_char_name) -> bool:
	if Constants.ad_data.keys().has(_char_name):
		return true
	return false
	
func is_character_beast(_char_name) -> bool:
	if Constants.beast_data.keys().has(_char_name):
		return true
	return false
	
func is_character_structure(_char_name) -> bool:
	if Constants.structure_data.keys().has(_char_name):
		return true
	return false
	
func is_character_ally(_char_name) -> bool:
	if _char_name == "steelthorn" or _char_name == "mariselle":
		return true
	return false
