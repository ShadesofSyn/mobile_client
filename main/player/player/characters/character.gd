extends CharacterBody2D


@onready var sprite: Sprite2D = $sprite
@onready var character_stats: Node = $character_stats
@onready var joystick = $Camera2D/player_gui/movement_joystick
@onready var player_gui = $Camera2D/player_gui

var lockstep_active = false

func _ready():
	character_stats.character_name = name
	if not name == "valkyrie" and not name == "technomancer":
		character_stats.is_ally = true
		$Camera2D.call_deferred("queue_free")
	else:
		Server.player_node = self


func use_special_ability() -> void:
	play_dash()


func play_dash() -> void:
	var dash = preload("res://main/player/abilities/dash/dash.tscn").instantiate()
	call_deferred("add_child",dash)


func basic_attack() -> void:
	match name:
		"valkyrie":
			pass
		"mariselle":
			InstancedScenes.init_mariselle_basic(character_stats.team_color,($line_of_sight/Marker2D.global_position-$line_of_sight.global_position).normalized(),$line_of_sight/Marker2D.global_position)
		"magmaul":
			pass
		"technomancer":
			InstancedScenes.init_technomancer_basic(character_stats.team_color,($line_of_sight/Marker2D.global_position-$line_of_sight.global_position).normalized(),$line_of_sight/Marker2D.global_position)



func ultra_attack() -> void:
	match name:
		"valkyrie":
			InstancedScenes.init_valkyrie_ultra(character_stats.team_color)
		"mariselle":
			InstancedScenes.init_mariselle_ultra(position,character_stats.team_color)
		"magmaul":
			InstancedScenes.init_magmaul_ultra(position,character_stats.team_color)

