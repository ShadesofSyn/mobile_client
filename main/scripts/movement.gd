extends Node


func _physics_process(delta):
	move_player(delta)

func move_player(delta) -> void:
	if get_parent().stats.STATE == Constants.player_state.DEATH:
		return
	var input_vector = get_parent().joystick.posVector.normalized()
	apply_movement(input_vector,delta)
	apply_friction(input_vector,delta)
	get_parent().move_and_slide()

func apply_movement(input_vector,delta) -> void:
	if not input_vector == Vector2.ZERO:
		get_parent().velocity = get_parent().velocity.move_toward(input_vector * Server.world.player_max_speed,Server.world.player_acceleration*delta)
	
func apply_friction(input_vector,delta) -> void:
	if input_vector == Vector2.ZERO:
		get_parent().velocity = get_parent().velocity.move_toward(Vector2.ZERO,Server.world.player_friction*delta)
