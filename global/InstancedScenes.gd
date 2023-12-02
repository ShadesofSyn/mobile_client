extends Node


func init_valk_ultra() -> void:
	var ult = preload("res://main/player/abilities/valkyrie/valk_ultra.tscn").instantiate()
	Server.player_node.call_deferred("add_child",ult)
