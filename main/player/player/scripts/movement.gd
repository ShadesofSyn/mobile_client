extends Node

const ATTACK_SPEED_RESTRUCTION = 0.8

var movement_type = Constants.ally_movement_state.NORMAL

func _physics_process(delta):
	if get_parent().character_stats.STATE == Constants.player_state.DEATH:
		return

	if get_parent().character_stats.TYPE == Constants.character_type.ALLY:
		move_ally(delta)

	elif get_parent().character_stats.TYPE == Constants.character_type.MAIN:
		move_player_from_joystick(delta)


func move_ally(delta) -> void:
	var lockstep_mode = Server.player_node.player_gui.lockstep_pressed
	if lockstep_mode:
		move_player_from_joystick(delta)


func move_player_from_joystick(delta) -> void:
	var input_vector = Server.player_node.joystick.output.normalized()
	apply_movement(input_vector,delta)
	apply_friction(input_vector,delta)
	get_parent().move_and_slide()

func apply_movement(input_vector,delta) -> void:
	if not input_vector == Vector2.ZERO:
		get_parent().get_node("line_of_sight").look_at(input_vector)
		if get_parent().character_stats.dashing:
			apply_dash_movement(input_vector,delta)
		else:
			apply_normal_movement(input_vector,delta)
	
func apply_friction(input_vector,delta) -> void:
	if input_vector == Vector2.ZERO:
		get_parent().velocity = get_parent().velocity.move_toward(Vector2.ZERO,get_parent().character_stats.friction*delta)


func apply_dash_movement(input_vector,delta) -> void:
	get_parent().velocity = get_parent().velocity.move_toward(input_vector*get_parent().character_stats.max_speed*Constants.DASH_SPEED_INCREASE,get_parent().character_stats.acceleration*delta*Constants.DASH_ACCEL_INCREASE)
	
func apply_normal_movement(input_vector,delta) -> void:
	if get_parent().sprite.attacking:
		get_parent().velocity = get_parent().velocity.move_toward(input_vector*get_parent().character_stats.max_speed*ATTACK_SPEED_RESTRUCTION,get_parent().character_stats.acceleration*delta)
	else:
		get_parent().velocity = get_parent().velocity.move_toward(input_vector*get_parent().character_stats.max_speed,get_parent().character_stats.acceleration*delta)
