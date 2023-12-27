extends CharacterBody2D

@onready var hurtbox: CollisionShape2D = $hurtbox/CollisionShape2D
@onready var character_stats = $character_stats
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $ad_navigation_agent

@export var MAX_SPEED = 100
@export var ACCELERATION = 50


var team_color: String
var anchor_mode: bool = false
var spawn_position: Vector2
var attacking: bool = false
var aggro_mode: bool = false

func _ready():
	character_stats.team_color = "red"
	character_stats.character_name = "golem"
	character_stats.TYPE = Constants.character_type.BEAST
	position = Vector2(-Constants.SIZE_OF_HEXAGON/3.46,-Constants.SIZE_OF_HEXAGON/2)
#	calculate_path()

func start_aggro_mode(is_first_ad):
#	if is_first_ad:
#		check_nearby_ads()
	print("START AGGRO")
	$detect_enemy/CollisionShape2D.shape.set_deferred("radius",64)
	navigation_agent.set_target_position(position)
	$ad_navigation_agent/Timer.stop()
	InstancedScenes.init_aggro_effect(self)
	await get_tree().create_timer(5*0.125).timeout
	aggro_mode = true
	$ad_navigation_agent/Timer.start(randf_range(0.1,0.2))


func _physics_process(delta):
	if Server.world:
		if attacking or character_stats.destroyed:
			return
		if Util.get_nearest_target($detect_enemy):
			attack()
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
		
		
func destroy():
	character_stats.destroyed = true
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	call_deferred("queue_free")


func _on_timer_timeout():
	pass # Replace with function body.
