extends Node

var character_name: String = "valkyrie"
var team_color: String = "blue"

var destroyed: bool = false
var dashing: bool = false
var invisible: bool = false

@export var max_speed: float = 250.0
@export var acceleration: float = 2000.0
@export var friction: float = 850.0


var STATE = Constants.player_state.IDLE

func _ready():
	await get_tree().process_frame
	get_node("../").set_collision_layer(Util.return_hurtbox_layer(team_color))


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
	get_parent().sprite.modulate.a = lerp(get_parent().sprite.modulate.a,0.3,_delta*5)
