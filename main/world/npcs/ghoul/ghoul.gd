extends CharacterBody2D

@onready var character_stats = $character_stats
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $ad_navigation_agent

@export var MAX_SPEED = 240
@export var ACCELERATION = 90


var team_color: String

var anchor_mode: bool = false

var spawn_position: Vector2
var attacking: bool = false

func _ready():
	spawn_position = position
	character_stats.team_color = "red"
	character_stats.character_name = "ghoul"
	character_stats.TYPE = Constants.character_type.AD
	calculate_path()



func _physics_process(delta):
	return
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
		sprite.position.x = 37
	else:
		sprite.flip_h = true
		sprite.position.x = -37


func destroy():
	set_physics_process(false)
	character_stats.destroyed = true
	sprite.play("death")
	await sprite.animation_finished
	call_deferred("queue_free")


func _on_timer_timeout():
	$ad_navigation_agent/Timer.start(randf_range(0.15,1.0))
	calculate_path()


func calculate_path():
	var target = Util.get_nearest_target($detect_enemy)
	if target == null:
		navigation_agent.set_target_position(Util.return_random_idle_position(spawn_position))
		return
	navigation_agent.set_target_position(target.global_position)


func start_agro_mode():
	character_stats.agro_mode = true
	$agro_label/AnimationPlayer.play("animate")

#
func _on_timer_2_timeout():

	if $hitbox/CollisionShape2D.disabled:
		$hitbox/CollisionShape2D.set_deferred("disabled", false)
	else:
		$hitbox/CollisionShape2D.set_deferred("disabled", true)
	
