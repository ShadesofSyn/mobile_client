extends CharacterBody2D


@onready var sprite: Sprite2D = $sprite
@onready var stats: Node = $stats
@onready var joystick = $Camera2D/player_gui/movement_joystick
@onready var player_gui = $Camera2D/player_gui


func _ready():
	Server.player_node = self

func _physics_process(delta):
	$Camera2D.zoom = Server.world.cam_zoom


func use_special_ability() -> void:
	play_dash()


func play_dash() -> void:
	stats.dashing = true
	var dash = preload("res://main/player/abilities/dash/dash.tscn").instantiate()
	call_deferred("add_child",dash)



func ultra_attack() -> void:
	InstancedScenes.init_valk_ultra()

