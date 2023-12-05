extends CharacterBody2D

@onready var character_stats = $character_stats
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@export var MAX_SPEED = 240
@export var ACCELERATION = 90


var team_color: String

var anchor_mode: bool = false


func _ready():
	character_stats.team_color = "white"
	character_stats.character_name = name
	calculate_path()



func _physics_process(delta):
	if Server.world:
		if navigation_agent.is_navigation_finished():
			velocity = velocity.move_toward(Vector2.ZERO,character_stats.friction*delta)
		else:
			set_direction()
			var target = navigation_agent.get_next_path_position()
			var move_direction = position.direction_to(target)
			var desired_velocity = move_direction * navigation_agent.max_speed
			var steering = (desired_velocity - velocity) * delta * 4.0
			velocity += steering
		move_and_slide()


func set_direction():
	if velocity.x > 0:
		sprite.flip_h = false
		sprite.position.x = 42
	else:
		sprite.flip_h = true
		sprite.position.x = -42



func destroy():
	set_physics_process(false)
	character_stats.destroyed = true
	sprite.play("death")
	await sprite.animation_finished
	Util.add_item_drop_to_world(position+Vector2(randf_range(-16,16),randf_range(-16,16)))
	call_deferred("queue_free")


func _on_timer_timeout():
	$Timer.start(randf_range(1,2))
	calculate_path()
	

func calculate_path():
#	var chars = Server.world.get_node("spawn_characters/characters").get_children()
	var target = Util.get_nearest_target($detect_enemy)
	if target == null:
		navigation_agent.set_target_position(Vector2.ZERO+Vector2(randi_range(-16,16),randi_range(-16,16)))
		return
	navigation_agent.set_target_position(target.global_position)



func _on_timer_2_timeout():
	if $hitbox/CollisionShape2D.disabled:
		$hitbox/CollisionShape2D.set_deferred("disabled", false)
	else:
		$hitbox/CollisionShape2D.set_deferred("disabled", true)
	
