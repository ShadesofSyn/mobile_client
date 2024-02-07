extends AnimatedSprite2D



func _ready():
	$red_team.set_collision_mask(Constants.RED_TEAM_HURTBOX_LAYER)
	$blue_team.set_collision_mask(Constants.BLUE_TEAM_HURTBOX_LAYER)
	$Timer.start(randf_range(10.0,20.0))



#func _physics_process(delta):
#	if $red_team.has_overlapping_bodies() and not $blue_team.has_overlapping_bodies():
#		set_red_team_state()
#	elif $blue_team.has_overlapping_bodies() and not $red_team.has_overlapping_bodies():
#		set_blue_team_state()
#	else:
#		set_empty_state()
#
#
#
#func set_red_team_state() -> void:
#	$flag.modulate = Color("ffffff")
#	border.material.set_shader_parameter("color1",Color("ff000000"))
#	border.material.set_shader_parameter("color2",Color("ff000098"))
#	border.material.set_shader_parameter("color3",Color("ffffff00"))
##	outline.material.set_shader_parameter("outline_color",Color("fa0000"))
#
#func set_blue_team_state() -> void:
#	$flag.modulate = Color("00ffff")
#	border.material.set_shader_parameter("color1",Color("0000ff00"))
#	border.material.set_shader_parameter("color2",Color("223cff98"))
#	border.material.set_shader_parameter("color3",Color("ffffff00"))
##	outline.material.set_shader_parameter("outline_color",Color("0030ff"))
#
#func set_empty_state() -> void:
#	$flag.modulate = Color("2e2024")
#	border.material.set_shader_parameter("color1",Color("ffffff00"))
#	border.material.set_shader_parameter("color2",Color("ffffff7e"))
#	border.material.set_shader_parameter("color3",Color("ffffff00"))
##	outline.material.set_shader_parameter("outline_color",Color("ffffff"))
#
#
#func _on_timer_timeout():
#	return
#	var favor = Server.player_node.player_gui.get_node("favor_bar")
#	if name == "hotzone" and $flag.modulate == Color("ffffff"):
#		favor.right_team_score += 1
#		favor.set_right_team_position()
#	elif name == "hotzone" and $flag.modulate == Color("00ffff"):
#		favor.left_team_score += 1
#		favor.set_left_team_position()


func _on_timer_timeout():
	$Timer.start(randf_range(10.0,20.0))
	play("open")
	await animation_finished
#	$beacon.show()
	await get_tree().create_timer(4.0).timeout
	$beacon.hide()
	play("close")
