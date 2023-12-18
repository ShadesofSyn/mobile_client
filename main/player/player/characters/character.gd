extends CharacterBody2D


@onready var sprite: Sprite2D = $sprite
@onready var character_stats: Node = $character_stats
@onready var joystick = $Camera2D/player_gui/movement_joystick
@onready var player_gui = $Camera2D/player_gui

var lockstep_active = false

func _ready():
	character_stats.character_name = name
	if not name == "valkyrie" and not name == "technomancer":
		character_stats.TYPE = Constants.character_type.ALLY
		$Camera2D.call_deferred("queue_free")
		if not Server.ally_node1:
			Server.ally_node1 = self
		else:
			Server.ally_node2 = self
	else:
		Server.player_node = self


func use_special_ability() -> void:
	play_dash()


func play_dash() -> void:
	var dash = preload("res://main/player/abilities/dash/dash.tscn").instantiate()
	call_deferred("add_child",dash)


func basic_attack() -> void:
	await get_tree().process_frame
	var spawn_point = $line_of_sight/Marker2D.global_position
	var aim_vector = (spawn_point-$line_of_sight.global_position).normalized()
	sprite.set_direction_attack_mode(aim_vector)
	match name:
		"mariselle":
			InstancedScenes.init_mariselle_basic(character_stats.team_color,aim_vector,spawn_point)
		"magmaul":
			InstancedScenes.init_magmaul_basic(character_stats.team_color,spawn_point)
		"technomancer":
			InstancedScenes.init_technomancer_basic(character_stats.team_color,aim_vector,spawn_point)
		"steelthorn":
			InstancedScenes.init_steelthorn_basic(character_stats.team_color,aim_vector,spawn_point)
		_:
			InstancedScenes.init_valkyrie_basic(character_stats.team_color,aim_vector,spawn_point)


func ultra_attack() -> void:
	await get_tree().process_frame
	var spawn_point = $line_of_sight/Marker2D.global_position
	var aim_vector = (spawn_point-$line_of_sight.global_position).normalized()
	sprite.set_direction_attack_mode(aim_vector)
	if name == "valkyrie" or name == "technomancer":
		sprite.attack(false)
	else:
		sprite.ultra_attack()
	match name:
		"valkyrie":
			InstancedScenes.init_valkyrie_ultra(character_stats.team_color)
		"mariselle":
			InstancedScenes.init_mariselle_ultra(position,character_stats.team_color)
		"magmaul":
			InstancedScenes.init_magmaul_ultra(position,character_stats.team_color)
		"technomancer":
			InstancedScenes.init_technomancer_ultra(position,character_stats.team_color)
		"steelthorn":
			InstancedScenes.init_steelthorn_ultra(position,character_stats.team_color)

