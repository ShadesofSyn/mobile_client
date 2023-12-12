extends TextureRect

const dist_to_btn: float = 40.0
#var being_pressed: bool = false

#	if event is InputEventScreenTouch:
#		if event.pressed:
#			if _is_point_inside_button_area(event.position):
#				Server.player_node.lockstep_active = true
#				play_button_pressed()
#		else:
#			Server.player_node.lockstep_active = false
#	elif event is InputEventKey:
#		if event.is_action_pressed("shift"):
#			Server.player_node.lockstep_active = true
#			play_button_pressed()
#
#
#func _is_point_inside_button_area(point:Vector2) -> bool:
#	var x: bool = point.x >= global_position.x+dist_to_btn and point.x <= global_position.x - dist_to_btn + (size.x * get_global_transform_with_canvas().get_scale().x)
#	var y: bool = point.y >= global_position.y+dist_to_btn and point.y <= global_position.y - dist_to_btn + (size.y * get_global_transform_with_canvas().get_scale().y)
#	return x and y
#
#func play_button_pressed() -> void:
#	var tween = get_tree().create_tween()
#	tween.tween_property(self,"scale",Vector2(0.72,0.72),0.1).set_ease(Tween.EASE_IN)
#	await get_tree().create_timer(0.3).timeout
#	var tween2 = get_tree().create_tween() 
#	tween2.tween_property(self,"scale",Vector2(0.75,0.75),0.1).set_ease(Tween.EASE_IN)
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _is_point_inside_button_area(event.position):
				get_node("../../").lockstep_pressed = true
#				attack()
			else:
				get_node("../../").lockstep_pressed = false
		else:
			get_node("../../").lockstep_pressed = false
	elif event is InputEventKey:
		if event.is_action_pressed("shift"):
			get_node("../../").lockstep_pressed = true
		elif event.is_action_released("shift"):
			get_node("../../").lockstep_pressed = false

func _physics_process(delta):
	if get_node("../../").lockstep_pressed:
		set_btn_pressed(delta)
	else:
		set_btn_normal(delta)


func _is_point_inside_button_area(point:Vector2) -> bool:
	var x: bool = point.x >= global_position.x+dist_to_btn and point.x <= global_position.x - dist_to_btn + (size.x * get_global_transform_with_canvas().get_scale().x)
	var y: bool = point.y >= global_position.y+dist_to_btn and point.y <= global_position.y - dist_to_btn + (size.y * get_global_transform_with_canvas().get_scale().y)
	return x and y


func set_btn_pressed(delta) -> void:
	self.scale = lerp(self.scale,Vector2(0.7,0.7),delta*5)
	
	
func set_btn_normal(delta) -> void:
	self.scale = lerp(self.scale,Vector2(0.75,0.75),delta*5)
