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
	character_stats.team_color = "white"
	character_stats.character_name = "golem"
	character_stats.TYPE = Constants.character_type.BEAST
#	calculate_path()


func _physics_process(delta):
	if Server.world:
		if attacking:
			return
#		if Util.get_nearest_target($detect_enemy):
#			attack()
		if navigation_agent.is_navigation_finished() or character_stats.destroyed:
			velocity = velocity.move_toward(Vector2.ZERO,character_stats.friction*delta)
		else:
			set_direction()
			var target = navigation_agent.get_next_path_position()
			var move_direction = position.direction_to(target)
			var desired_velocity = move_direction * navigation_agent.max_speed
			var steering = (desired_velocity - velocity) * delta * 4.0
			velocity += steering
		set_sprite_state()
		move_and_slide()

func attack():
	if not attacking:
		attacking = true
		$AnimatedSprite2D.play("attack")
		await $AnimatedSprite2D.animation_finished
		$hitbox/CollisionShape2D.set_deferred("disabled",false)
		await get_tree().create_timer(0.1).timeout
		$hitbox/CollisionShape2D.set_deferred("disabled",true)
		attacking = false


func set_sprite_state():
	if attacking:
		return
	if character_stats.destroyed:
		$AnimatedSprite2D.play("death")
	elif velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("walk")


func set_direction():
	if velocity.x > 0:
		sprite.flip_h = false
		sprite.position.x = 108
	else:
		sprite.flip_h = true
		sprite.position.x = -108
