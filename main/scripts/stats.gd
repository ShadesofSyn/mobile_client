extends Node

var character_name: String = "player"
var team_color: String = "blue"

var destroyed: bool = false
var dashing: bool = false
var invisible: bool = false
#
#@export var max_speed: float = 200.0
#@export var acceleration: float = 750.0
#@export var friction: float = 650.0



var STATE = Constants.player_state.IDLE

#func _ready():
#	await get_tree().process_frame
#	if team_color == "red":
#		get_node("../").set_collision_layer(1+4+32)
#	else:
#		get_node("../").set_collision_layer(2+4+32)


func _process(delta):
	if Server.world:
		if in_tall_grass_square():
			set_player_invisible(delta)
		else:
			set_player_visible(delta)


func in_tall_grass_square() -> bool:
	if Server.world.tall_grass_tiles.get_used_cells(0).has(Server.world.tall_grass_tiles.local_to_map(get_parent().position)):
		return true
	return false 


func set_player_visible(_delta):
	get_parent().sprite.modulate.a = lerp(get_parent().sprite.modulate.a,1.0,_delta*5)
	
func set_player_invisible(_delta):
	get_parent().sprite.modulate.a = lerp(get_parent().sprite.modulate.a,0.5,_delta*5)
