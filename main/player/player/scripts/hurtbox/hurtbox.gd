extends Area2D

@onready var progress_bar: TextureProgressBar = $health_progress_bar
@onready var h

func _ready():
	await get_tree().create_timer(0.2).timeout
	if get_parent().character_stats:
		set_hurtbox_stats()
		set_team_stats(get_parent().character_stats.team_color)
	else:
		printerr("INVALID HURTBOX SETUP")


func set_hurtbox_stats() -> void:
	if get_parent().character_stats.TYPE == Constants.character_type.AD:
		progress_bar.max_value = Constants.ad_data[get_parent().character_stats.character_name]["basic"]["health"]
	elif get_parent().character_stats.TYPE == Constants.character_type.BEAST:
		progress_bar.max_value = Constants.beast_data[get_parent().character_stats.character_name]["basic"]["health"]
	elif get_parent().character_stats.TYPE == Constants.character_type.STRUCTURE:
		progress_bar.max_value = Constants.structure_data[get_parent().character_stats.character_name]["basic"]["health"]
	else:
		progress_bar.max_value = Constants.character_data[get_parent().character_stats.character_name]["basic"]["health"]
	progress_bar.value = progress_bar.max_value
	$Label.text = str(progress_bar.value)


func set_team_stats(_team_color) -> void:
	set_collision_mask(Util.return_hurtbox_layer(_team_color))
	match _team_color:
		"blue":
			$Label.modulate = Color("00dbff")
		"red":
			$Label.modulate = Color("ff4961")
		"white":
			$Label.modulate = Color("ffffff")


func _on_area_entered(area):
	if not get_parent().character_stats.destroyed:
		var hitbox_character_name = area.hitbox_character_name
		var hitbox_type =  area.hitbox_attack_type
		var health_change
		if hitbox_type == "special" and hitbox_character_name == "unstable core":
			health_change = -(progress_bar.value/2)
#		print("ENTERED HURTBOX " + str(get_parent().name) + " " + hitbox_character_name + " " + hitbox_type)
		elif hitbox_character_name == "mariselle" and hitbox_type == "ultra":
			health_change = int((Constants.character_data["mariselle"]["ultra"]["healPercentagePerAction"] * 0.01) * progress_bar.max_value)
		else:
			health_change = Util.return_health_change(hitbox_character_name,hitbox_type)
		progress_bar.value += health_change
		
		if progress_bar.value <= 0:
			destroy()
		else: 
			$Label.text = str(progress_bar.value)
			flash(health_change)
		if Util.destructable_projectile(hitbox_character_name,hitbox_type):
			area.destroy()
		InstancedScenes.init_hit_effect(health_change,global_position)
	if get_parent().character_stats.TYPE == Constants.character_type.AD or get_parent().character_stats.character_name == "golem":
		if not get_parent().character_stats.aggro_mode:
			get_parent().start_aggro_mode(true)
			


func destroy() -> void:
	if not get_parent().character_stats.destroyed:
		hide()
		get_parent().destroy()
#		$Label.text = str(0)
#		if get_parent().character_stats.TYPE == Constants.character_type.STRUCTURE or get_parent().character_stats.TYPE == Constants.character_type.BEAST:
#			hide()
#			get_parent().destroy()
#		elif  get_parent().character_stats.TYPE == Constants.character_type.STRUCTURE:
#			hide()
#			get_parent().destroy()
#		elif not get_parent().character_stats.TYPE == Constants.character_type.MAIN:
#			hide()
#			get_parent().character_stats.destroyed = true
#			var sprite_material = get_parent().sprite.material
#			sprite_material.set_shader_parameter("flash_modifier",0)
#			await get_tree().process_frame
#			get_parent().character_stats.STATE = Constants.player_state.DEATH
#			await get_tree().create_timer(0.125*5).timeout
#			get_parent().destroy()
#		else:
#			get_parent().sprite.destroy()


func flash(_health_change) -> void:
	if _health_change > 0:
		flash_green()
	else:
		flash_red()


func flash_green() -> void:
	var sprite_material = get_parent().sprite.material
	sprite_material.set_shader_parameter("flash_color",Color("00b800"))
	sprite_material.set_shader_parameter("flash_modifier", 0.75)
	await get_tree().create_timer(0.15).timeout
	sprite_material.set_shader_parameter("flash_modifier", 0)


func flash_red() -> void:
	var sprite_material = get_parent().sprite.material
	sprite_material.set_shader_parameter("flash_color",Color("b80000"))
	sprite_material.set_shader_parameter("flash_modifier", 0.75)
	await get_tree().create_timer(0.15).timeout
	sprite_material.set_shader_parameter("flash_modifier", 0)

