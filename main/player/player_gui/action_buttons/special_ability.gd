extends TextureRect


const dist_to_btn: float = 40.0



func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _is_point_inside_button_area(event.position):
				$cooldown.start(10)
				Server.player_node.use_special_ability()
				play_button_pressed()
	elif event is InputEventKey:
		if event.is_action_pressed("space"):
			$cooldown.start(10)
			Server.player_node.use_special_ability()
			play_button_pressed()


func _is_point_inside_button_area(point:Vector2) -> bool:
	var x: bool = point.x >= global_position.x+dist_to_btn and point.x <= global_position.x - dist_to_btn + (size.x * get_global_transform_with_canvas().get_scale().x)
	var y: bool = point.y >= global_position.y+dist_to_btn and point.y <= global_position.y - dist_to_btn + (size.y * get_global_transform_with_canvas().get_scale().y)
	return x and y

func play_button_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self,"scale",Vector2(0.72,0.72),0.1).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(0.3).timeout
	var tween2 = get_tree().create_tween() 
	tween2.tween_property(self,"scale",Vector2(0.75,0.75),0.1).set_ease(Tween.EASE_IN)
