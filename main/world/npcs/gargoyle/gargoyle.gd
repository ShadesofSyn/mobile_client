extends CharacterBody2D


@onready var character_stats = $character_stats
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $ad_navigation_agent

@export var MAX_SPEED = 100
@export var ACCELERATION = 50


var team_color: String
var anchor_mode: bool = false
var spawn_position: Vector2
var attacking: bool = false


func _ready():
	character_stats.team_color = "red"
	character_stats.character_name = "gargoyle"
	character_stats.TYPE = Constants.character_type.BEAST
