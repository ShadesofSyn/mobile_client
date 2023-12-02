extends Control

@onready var player_icon1 = $map/player

var PLAYER_DIST_TO_CORNER
const ICON_DIST_TO_CORNER = 216

func _process(delta):
	if Server.world:
		PLAYER_DIST_TO_CORNER = Server.world.hex_size
		var target = Server.player_node.position / (PLAYER_DIST_TO_CORNER / ICON_DIST_TO_CORNER)
		player_icon1.position = lerp(player_icon1.position,target,delta*5)
