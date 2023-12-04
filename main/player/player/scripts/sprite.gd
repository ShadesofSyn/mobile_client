extends Sprite2D

var direction = "S"


var attacking: bool = false
var frame_index: int = 0
var max_frame_index: int = 0

var desired_direction_index: int = 0
var current_direction_index: int = 0

const directions = [  
		"N", 
		"NE",
		"E", 
		"SE",
		"S",
		"SW",
		"W",
		"NW"]


#const directions = [  
#		"N", 
#		"NNE", "NE", "NEE",
#		"E", 
#		"SEE", "SE", "SSE",
#		"S",
#		"SSW", "SW", "SWW",
#		"W",
#		"NWW", "NW", "NNW"]


func _process(delta):
	set_sprite_direction(delta)
	set_sprite_state()
	set_sprite_texture()


func set_sprite_state() -> void:
	if get_parent().stats.destroyed or get_parent().stats.STATE == Constants.player_state.ATTACK:
		return
	if get_parent().joystick.output == Vector2.ZERO:
		if not get_parent().stats.STATE == Constants.player_state.IDLE:
			frame_index = 0
			max_frame_index = 0
			get_parent().stats.STATE = Constants.player_state.IDLE
	else:
		if not get_parent().stats.STATE == Constants.player_state.WALK:
			frame_index = 0
			max_frame_index = 3
			get_parent().stats.STATE = Constants.player_state.WALK


func attack():
	attacking = true
	frame_index = 0
	max_frame_index = 4
	get_parent().stats.STATE = Constants.player_state.ATTACK
#	position.y += 9
	await get_tree().create_timer(0.2).timeout
	if get_parent().stats.destroyed:
		attacking = false
		return
#	spawn_hammer_projectile()
	await get_tree().create_timer(0.2).timeout
#	position.y += -9
	attacking = false
	if get_parent().stats.destroyed:
		return
	get_parent().stats.STATE = Constants.player_state.WALK



#func spawn_hammer_projectile():
#	var projectile = preload("res://main/roguelike/lords_of_pain/fighter/hammer_projectile.tscn").instantiate()
#	projectile.rotation_degrees = get_node("../line_of_sight").rotation_degrees
#	projectile.position = get_node("../line_of_sight").global_position
#	Server.world.get_node("projectiles").call_deferred("add_child",projectile)


func set_sprite_direction(delta) -> void:
	if get_parent().stats.destroyed:
		return
	if not get_parent().stats.STATE == Constants.player_state.ATTACK:
		set_sprite_direction_movement_mode(delta)
	else:
		set_direction_attack_mode()


func set_direction_attack_mode():
	return
	var attack_point = get_node("../line_of_sight/hitbox").global_position - get_node("../line_of_sight").global_position
	var angle = rad_to_deg(Vector2(1,0).angle_to(attack_point))+90
	print(str((angle/22.5)+.5))
	desired_direction_index = int((angle/22.5)+.5)
	direction = directions[desired_direction_index]


func set_sprite_direction_movement_mode(delta) -> void:
	var joystick_vector = get_parent().joystick.output
	if joystick_vector == Vector2.ZERO:
		get_parent().stats.STATE = Constants.player_state.IDLE
		return
	get_parent().stats.STATE = Constants.player_state.WALK
	var angle = rad_to_deg(Vector2(1,0).angle_to(joystick_vector))+90
	if angle < 0:
		angle = angle + 360
	desired_direction_index = int((angle/45)+.5)
	if desired_direction_index == 8:
		desired_direction_index = 0
	direction = directions[desired_direction_index]
#	desired_direction_index = int((angle/22.5)+.5)
#	direction = directions[desired_direction_index]


func set_sprite_texture(): 
	match get_parent().stats.STATE:
		Constants.player_state.IDLE:
			frame_index = 0
			max_frame_index = 0
			self.texture = load("res://assets/characters/"+get_parent().stats.character_name+"/walk/"+direction+"/000"+ str(frame_index+1) +".png")
		Constants.player_state.WALK:
			max_frame_index = 3
			self.texture = load("res://assets/characters/"+get_parent().stats.character_name+"/walk/"+direction+"/000"+ str(frame_index+1) +".png") #load("res://assets/characters/fighter/walk/"+direction+"/"+ str(frame_index) +".png")
		Constants.player_state.ATTACK:
			max_frame_index = 4
			self.texture = load("res://assets/characters/valkyrie/attack idle/"+direction+"/000"+ str(frame_index+1) +".png")
#		Constants.player_state.DEATH:
#			max_frame_index = 7
#			self.texture = load("res://assets/characters/fighter/death/"+direction+"/"+ str(frame_index) +".png")


func _on_timer_timeout():
	if get_parent().stats.STATE == Constants.player_state.DEATH and frame_index == max_frame_index:
		return
	frame_index += 1
	if frame_index > max_frame_index:
		frame_index = 0


func destroy():
	if not get_parent().stats.destroyed:
		get_parent().stats.destroyed = true
		material.set_shader_parameter("flash_modifier", 0)
		await get_tree().process_frame
		get_parent().stats.STATE = get_parent().stats.DEATH
		frame_index = 0
		await get_tree().create_timer(2.0).timeout
		respawn()


func respawn():
	get_parent().stats.STATE = get_parent().stats.IDLE
	get_parent().position = get_parent().spawn_position
	get_parent().destroyed = false
	get_node("../hurtbox").health = get_node("../hurtbox").max_health
	get_node("../hurtbox/ProgressBar").value = get_node("../hurtbox").max_health
	get_node("../hurtbox/ProgressBar").show()
	get_node("../CollisionShape2D").set_deferred("disabled",false)
	get_node("../hurtbox/CollisionShape2D").set_deferred("disabled",false)


func flash(hitbox_name):
	if hitbox_name == "nanomedic heal":
		material.set_shader_parameter("flash_color",Color("00ff00"))
	else:
		material.set_shader_parameter("flash_color",Color("ffffff"))
	material.set_shader_parameter("flash_modifier", 1)
	await get_tree().create_timer(0.1).timeout
	material.set_shader_parameter("flash_modifier", 0)
