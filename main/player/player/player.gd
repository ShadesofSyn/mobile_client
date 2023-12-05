extends CharacterBody2D


@onready var sprite: Sprite2D = $sprite
@onready var character_stats: Node = $character_stats
@onready var joystick = $Camera2D/player_gui/movement_joystick
@onready var player_gui = $Camera2D/player_gui


func _ready():
	Server.player_node = self
	character_stats.character_name = "valkyrie"


func use_special_ability() -> void:
	play_dash()


func play_dash() -> void:
	var dash = preload("res://main/player/abilities/dash/dash.tscn").instantiate()
	call_deferred("add_child",dash)



func ultra_attack() -> void:
	InstancedScenes.init_valk_ultra()

