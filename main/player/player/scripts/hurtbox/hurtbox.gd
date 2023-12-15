extends Area2D

@onready var progress_bar: TextureProgressBar = $health_progress_bar


func _ready():
	await get_tree().process_frame
	if get_parent().character_stats:
		set_hurtbox_stats()
		set_team_stats(get_parent().character_stats.team_color)
	else:
		printerr("INVALID HURTBOX SETUP")


func set_hurtbox_stats() -> void:
	if get_parent().character_stats.TYPE == Constants.character_type.AD:
		progress_bar.max_value = Constants.ad_data[get_parent().character_stats.character_name]["baseStats"]["health"]
	else:
		progress_bar.max_value = Constants.character_data[get_parent().character_stats.character_name]["baseStats"]["health"]
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
		var hitbox_name = area.hitbox_name
		var health_change
		if hitbox_name == "mariselle ultra":
			health_change = int((Constants.character_data["mariselle"]["ultimate"]["healPercentagePerAction"] * 0.01) * progress_bar.max_value)
		else:
			health_change = Util.return_health_change(hitbox_name)
		progress_bar.value += health_change
		
		if progress_bar.value < 0:
			destroy()
		else: 
			$Label.text = str(progress_bar.value)
			flash(health_change)
			print("HEALTH CHANGE " + str(health_change))


func destroy() -> void:
	material.set_shader_parameter("flash_modifier", 0)
	await get_tree().process_frame
	get_parent().character_stats.STATE = Constants.player_state.DEATH
	await get_tree().create_timer(2.0).timeout


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

