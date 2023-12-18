extends TextureRect

const dist_to_btn: float = 0.0

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _is_point_inside_button_area(event.position) and not $cooldown.visible:
				$cooldown.start(1)
				ultra_attack()
				play_button_pressed()


func _is_point_inside_button_area(point:Vector2) -> bool:
	var x: bool = point.x >= global_position.x+dist_to_btn and point.x <= global_position.x - dist_to_btn + (size.x * get_global_transform_with_canvas().get_scale().x)
	var y: bool = point.y >= global_position.y+dist_to_btn and point.y <= global_position.y - dist_to_btn + (size.y * get_global_transform_with_canvas().get_scale().y)
	return x and y


func play_button_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self,"scale",Vector2(0.95,0.95),0.1).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(0.3).timeout
	var tween2 = get_tree().create_tween() 
	tween2.tween_property(self,"scale",Vector2(1.0,1.0),0.1).set_ease(Tween.EASE_IN)


func ultra_attack():
	match name.right(1):
		"1":
			Server.player_node.ultra_attack()
		"2":
			Server.ally_node1.ultra_attack()
		"3":
			Server.ally_node2.ultra_attack()


