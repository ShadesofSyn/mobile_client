extends Node

var character_name: String = "valkyrie"
var team_color: String = "blue"

var destroyed: bool = false
var dashing: bool = false
var invisible: bool = false
var agro_mode: bool = false

@export var max_speed: float = 250.0
@export var acceleration: float = 2000.0
@export var friction: float = 850.0

var TYPE = Constants.character_type.MAIN
var STATE = Constants.player_state.IDLE

func _ready():
	await get_tree().process_frame
	set_character_type()
	set_character_attributes()


func set_character_type():
	if Util.is_character_ad(character_name):
		TYPE = Constants.character_type.AD
	elif Util.is_character_beast(character_name):
		TYPE = Constants.character_type.BEAST
	elif Util.is_character_ally(character_name):
		TYPE = Constants.character_type.ALLY
	else:
		TYPE = Constants.character_type.MAIN


func set_character_attributes():
	match TYPE:
		Constants.character_type.AD:
			get_node("../").set_collision_layer(Util.return_hurtbox_layer(team_color)+16)
			max_speed = Constants.ad_data[character_name]["basic"]["movementSpeed"] * 18
		Constants.character_type.BEAST:
			max_speed = Constants.beast_data[character_name]["basic"]["movementSpeed"] * 18
		_:
			get_node("../").set_collision_layer(Util.return_hurtbox_layer(team_color)+16)
			max_speed = Constants.character_data[character_name]["basic"]["movementSpeed"] * 18



#func _physics_process(delta):
#	if Server.world:
#		if in_tall_grass_square():
#			set_player_invisible(delta)
#		else:
#			set_player_visible(delta)
#
#
#func in_tall_grass_square() -> bool:
#	if Server.world.tall_grass_tiles.get_used_cells(0).has(Server.world.tall_grass_tiles.local_to_map(get_parent().position)):
#		return true
#	return false 


#func set_player_visible(_delta):
#	get_parent().sprite.modulate.a = lerp(get_parent().sprite.modulate.a,1.0,_delta*5)
#
#func set_player_invisible(_delta):
#	get_parent().sprite.modulate.a = lerp(get_parent().sprite.modulate.a,0.3,_delta*5)
