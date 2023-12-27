extends Node2D

var dropped: bool = false


#func _physics_process(delta):
#	deploy_mode()


func init():
	$indicator.hide()
	if Util.validate_tiles(Vector2i(position/80),Vector2i(2,2)):
#		$Timer.start()
		$StaticBody2D/CollisionShape2D.set_deferred("disabled",false)
		Util.remove_valid_tiles(Vector2i(position/80),Vector2i(2,2))
		dropped = true
		Server.player_node.player_gui.get_node("action_rewards").remove_object_from_gui(name)
	else:
		call_deferred("queue_free")


func deploy_mode():
	if not dropped:
		position = (get_global_mouse_position()+Vector2(40,-40)).snapped(Vector2(80,80))
		if Util.validate_tiles(Vector2i(position/80),Vector2i(2,2)):
			$indicator.texture = preload("res://assets/images/misc/green_square.png")
		else:
			$indicator.texture = preload("res://assets/images/misc/red_square.png")
