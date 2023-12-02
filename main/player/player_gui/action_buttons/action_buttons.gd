extends Control

#
#const dist_to_btn: float = 0.0
#
#func _input(event: InputEvent) -> void:
#	if event is InputEventScreenTouch:
#		if event.pressed:
#			if _is_point_inside_button_area(event.position):
##				self.texture = preload("res://assets/images/game/gui/buttons/green.png")
#				Server.player_node.sprite.attack()
#				$basic/AnimationPlayer.play("pressed")
#				await get_tree().create_timer(1.0).timeout
##				self.texture = preload("res://assets/images/game/gui/buttons/green glow.png")
#
#
#
#func _is_point_inside_button_area(point:Vector2) -> bool:
#	var x: bool = point.x >= global_position.x+dist_to_btn and point.x <= global_position.x - dist_to_btn + (size.x * get_global_transform_with_canvas().get_scale().x)
#	var y: bool = point.y >= global_position.y+dist_to_btn and point.y <= global_position.y - dist_to_btn + (size.y * get_global_transform_with_canvas().get_scale().y)
#	return x and y

