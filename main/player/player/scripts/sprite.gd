extends Sprite2D

var direction = "S"

var attack_cooldown_active: bool = false
var attacking: bool = false
var ultra_attacking: bool = false
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

func _ready():
	await get_tree().process_frame
	max_frame_index = return_walk_max_frames()
	$Timer.start(0.125)


func _physics_process(delta):
	if not get_parent().character_stats.TYPE == Constants.character_type.ALLY:
		set_sprite_direction(delta)
		set_main_sprite_state()
		set_sprite_texture()
	else:
		set_direction_ally_mode(delta)
		set_ally_sprite_state()
		set_sprite_texture()


func set_direction_ally_mode(delta) -> void:
	var velocity = get_parent().velocity
	if velocity == Vector2.ZERO or attacking:
		return
	var angle = rad_to_deg(Vector2(1,0).angle_to(velocity))+90
	if angle < 0:
		angle = angle + 360
	desired_direction_index = int((angle/45)+.5)
	if desired_direction_index == 8:
		desired_direction_index = 0
	direction = directions[desired_direction_index]

func set_ally_sprite_state() -> void:
	if get_parent().character_stats.destroyed:
		return
	check_if_attack_mode()
	if ultra_attacking:
		if not get_parent().character_stats.STATE == Constants.player_state.ULTRA_ATTACK:
			get_parent().character_stats.STATE = Constants.player_state.ULTRA_ATTACK
	elif not attacking:
		if get_parent().velocity == Vector2.ZERO:
			if not get_parent().character_stats.STATE == Constants.player_state.IDLE:
				get_parent().character_stats.STATE = Constants.player_state.IDLE
		else:
			if not get_parent().character_stats.STATE == Constants.player_state.WALK:
				get_parent().character_stats.STATE = Constants.player_state.WALK
	else:
		if get_parent().velocity == Vector2.ZERO:
			if not get_parent().character_stats.STATE == Constants.player_state.ATTACK:
				get_parent().character_stats.STATE = Constants.player_state.ATTACK
		else:
			if not get_parent().character_stats.STATE == Constants.player_state.WALKING_ATTACK:
				get_parent().character_stats.STATE = Constants.player_state.WALKING_ATTACK


func check_if_attack_mode() -> void:
	if attacking or ultra_attacking:
		return 
	if Util.get_nearest_target(get_node("../detect_enemy")):
		attack()


func set_main_sprite_state() -> void:
	if get_parent().character_stats.destroyed or get_parent().character_stats.STATE == Constants.player_state.DEATH:
		return
	if ultra_attacking:
		if not get_parent().character_stats.STATE == Constants.player_state.ULTRA_ATTACK:
			get_parent().character_stats.STATE = Constants.player_state.ULTRA_ATTACK
	elif not attacking:
		if get_parent().joystick.output == Vector2.ZERO:
			if not get_parent().character_stats.STATE == Constants.player_state.IDLE:
				get_parent().character_stats.STATE = Constants.player_state.IDLE
		else:
			if not get_parent().character_stats.STATE == Constants.player_state.WALK:
				get_parent().character_stats.STATE = Constants.player_state.WALK
	else:
		if get_parent().joystick.output == Vector2.ZERO:
			if not get_parent().character_stats.STATE == Constants.player_state.ATTACK:
				get_parent().character_stats.STATE = Constants.player_state.ATTACK
		else:
			if not get_parent().character_stats.STATE == Constants.player_state.WALKING_ATTACK:
				get_parent().character_stats.STATE = Constants.player_state.WALKING_ATTACK

func attack(launch = true):
	if not attack_cooldown_active and not ultra_attacking:
		attacking = true
		frame_index = 0
		max_frame_index = return_attack_max_frames()
		if launch:
			start_cooldown()
			get_parent().basic_attack()
		await get_tree().create_timer(0.125*(return_attack_max_frames()+1)).timeout
		attacking = false
		max_frame_index = return_walk_max_frames()


func ultra_attack():
#	if not attack_cooldown_active:
	ultra_attacking = true
	frame_index = 0
	max_frame_index = return_ultra_attack_max_frames()
	await get_tree().create_timer(0.125*(return_ultra_attack_max_frames()+1)).timeout
	ultra_attacking = false
	max_frame_index = return_walk_max_frames()


func start_cooldown() -> void:
	attack_cooldown_active = true
	var char_name = get_parent().character_stats.character_name
	var cooldown_length = Constants.character_data[char_name]["basic"]["attackSpeed"]
	var pg_bar = get_parent().get_node("hurtbox/attack_progress_bar")
	pg_bar.value = 0
	var tween = get_tree().create_tween()
	tween.tween_property(pg_bar,"value",100,cooldown_length)
	await tween.finished
	attack_cooldown_active = false
	


#func spawn_hammer_projectile():
#	var projectile = preload("res://main/roguelike/lords_of_pain/fighter/hammer_projectile.tscn").instantiate()
#	projectile.rotation_degrees = get_node("../line_of_sight").rotation_degrees
#	projectile.position = get_node("../line_of_sight").global_position
#	Server.world.get_node("projectiles").call_deferred("add_child",projectile)


func set_sprite_direction(delta) -> void:
	if get_parent().character_stats.destroyed:
		return
	if not attacking:
		set_sprite_direction_movement_mode(delta)
#	else:
#		set_direction_attack_mode()


func set_direction_attack_mode(attack_vector):
#	var angle = get_node("../line_of_sight").rotation_degrees
#	var attack_point = (get_node("../line_of_sight/Marker2D").global_position - get_node("../line_of_sight").global_position).normalized()
#	print(attack_point)
	await get_tree().process_frame
	var angle = rad_to_deg(Vector2(1,0).angle_to(attack_vector))+90
	set_direction_from_angle(angle)


func set_sprite_direction_movement_mode(delta) -> void:
	var joystick_vector = get_parent().joystick.output
	if joystick_vector == Vector2.ZERO:
		return
	var angle = rad_to_deg(Vector2(1,0).angle_to(joystick_vector))+90
	set_direction_from_angle(angle)


func set_direction_from_angle(angle) -> void:
#	print(angle)
	if angle < 0:
		angle = angle + 360
	desired_direction_index = int((angle/45)+.5)
	if desired_direction_index == 8:
		desired_direction_index = 0
	direction = directions[desired_direction_index]
	if direction == "S":
		Server.ally_node1.get_node("ally_navigation_agent").follow_position = Vector2(-100,100)
		Server.ally_node2.get_node("ally_navigation_agent").follow_position = Vector2(100,100)
	elif direction == "E":
		Server.ally_node1.get_node("ally_navigation_agent").follow_position = Vector2(100,100)
		Server.ally_node2.get_node("ally_navigation_agent").follow_position = Vector2(100,-100)
	elif direction == "N":
		Server.ally_node1.get_node("ally_navigation_agent").follow_position = Vector2(-100,-100)
		Server.ally_node2.get_node("ally_navigation_agent").follow_position = Vector2(100,-100)
	elif direction == "W":
		Server.ally_node1.get_node("ally_navigation_agent").follow_position = Vector2(-100,100)
		Server.ally_node2.get_node("ally_navigation_agent").follow_position = Vector2(-100,-100)

func set_sprite_texture(): 
	var abbreviated_character_name = Util.return_abbreviated_character_name(get_parent().character_stats.character_name)
	match get_parent().character_stats.STATE:
		Constants.player_state.IDLE:
			frame_index = 0
			self.texture = load("res://assets/characters/"+get_parent().character_stats.character_name+"/walk/"+abbreviated_character_name+"-walking-"+direction.to_lower()+"-01.png")
		Constants.player_state.WALK:
			self.texture = load("res://assets/characters/"+get_parent().character_stats.character_name+"/walk/"+abbreviated_character_name+"-walking-"+direction.to_lower()+"-0"+str(frame_index+1)+".png") #load("res://assets/characters/fighter/walk/"+direction+"/"+ str(frame_index) +".png")
		Constants.player_state.ATTACK:
			self.texture = load("res://assets/characters/"+get_parent().character_stats.character_name+"/attack/"+abbreviated_character_name+"-attack-"+direction.to_lower()+"-0"+str(frame_index+1)+".png")
		Constants.player_state.WALKING_ATTACK:
			self.texture = load("res://assets/characters/"+get_parent().character_stats.character_name+"/walking_attack/"+abbreviated_character_name+"-walking-attack-"+direction.to_lower()+"-0"+str(frame_index+1)+".png")
		Constants.player_state.ULTRA_ATTACK:
			self.texture = load("res://assets/characters/"+get_parent().character_stats.character_name+"/casting_ultra/"+abbreviated_character_name+"-casting-ultra-"+direction.to_lower()+"-0"+str(frame_index+1)+".png")
		Constants.player_state.DEATH:
			self.texture = load("res://assets/characters/"+get_parent().character_stats.character_name+"/death/"+abbreviated_character_name+"-death-0"+str(frame_index+1)+".png")

func return_walk_max_frames():
	match get_parent().character_stats.character_name:
		"mariselle":
			return 7
		_:
			return 3

func return_attack_max_frames():
	match get_parent().character_stats.character_name:
		"technomancer":
			return 4
		_:
			return 3

func return_ultra_attack_max_frames():
	match get_parent().character_stats.character_name:
		"technomancer":
			return 4
		"magmaul":
			return 5
		"canix":
			return 4
		"mariselle":
			return 4
		"steelthorn":
			return 2
		_:
			return 3
	


func _on_timer_timeout():
	if get_parent().character_stats.STATE == Constants.player_state.DEATH and frame_index == max_frame_index:
		return
	frame_index += 1
	if frame_index > max_frame_index: 
		frame_index = 0


func destroy():
	if not get_parent().character_stats.destroyed:
		get_parent().character_stats.destroyed = true
		material.set_shader_parameter("flash_modifier", 0)
		await get_tree().process_frame
		get_parent().character_stats.STATE = Constants.player_state.DEATH
		frame_index = 0
		max_frame_index = 3
		await get_tree().create_timer(5.0).timeout
		respawn()


func respawn():
	get_parent().character_stats.STATE = Constants.player_state.IDLE
	get_parent().position = get_parent().spawn_position
	get_parent().character_stats.destroyed = false
	get_node("../hurtbox/health_progress_bar").value = get_node("../hurtbox/health_progress_bar").max_value
	get_node("../hurtbox/health_progress_bar").show()
	get_node("../hurtbox/Label").text = str(get_node("../hurtbox/health_progress_bar").max_value)
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
