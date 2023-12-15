extends NavigationAgent2D

@export var follow_position = Vector2(500,0)


func _physics_process(delta):
	var lockstep_mode = Server.player_node.player_gui.lockstep_pressed
	if lockstep_mode:
		return

	if self.is_navigation_finished():
		get_parent().velocity = get_parent().velocity.move_toward(Vector2.ZERO,get_parent().character_stats.friction*delta)
		get_parent().move_and_slide()
		return
	var target = self.get_next_path_position()
	var move_direction = get_parent().position.direction_to(target)
	var desired_velocity = move_direction * get_parent().character_stats.max_speed
	var steering = (desired_velocity - get_parent().velocity) * delta * 4.0
	get_parent().velocity += steering
	get_parent().move_and_slide()


func calculate_path(target_pos):
	self.set_target_position(target_pos)


func _on_timer_timeout():
	calculate_path(Server.player_node.global_position + follow_position)
