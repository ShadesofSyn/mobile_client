extends CharacterBody2D


@onready var sprite: Sprite2D = $sprite
@onready var stats: Node = $stats
@onready var joystick = $Camera2D/player_gui/movement_joystick


func _ready():
	Server.player_node = self

func _physics_process(delta):
	if Server.world:
		$Camera2D.zoom = Server.world.camera_zoom_amt
