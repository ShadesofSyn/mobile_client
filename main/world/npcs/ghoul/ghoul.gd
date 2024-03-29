extends CharacterBody2D

@onready var hurtbox: CollisionShape2D = $hurtbox/CollisionShape2D
@onready var character_stats = $character_stats
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $ad_navigation_agent


var team_color: String

var spawn_position: Vector2
var attacking: bool = false

#var aggro_mode: bool = false


func _ready():
	spawn_position = position
	character_stats.team_color = "red"
	character_stats.character_name = "ghoul"
	$hitbox.set_collision_layer(Util.return_hitbox_layer(character_stats.team_color))
	$ad_navigation_agent/Timer.start(randf_range(3.0,8.0))

func start_aggro_mode(is_first_ad):
	if is_first_ad:
		check_nearby_ads()
	$detect_enemy/CollisionShape2D.shape.set_deferred("radius",64)
	navigation_agent.set_target_position(position)
	$ad_navigation_agent/Timer.stop()
	InstancedScenes.init_aggro_effect(self)
	await get_tree().create_timer(5*0.125).timeout
	character_stats.aggro_mode = true
	$ad_navigation_agent/Timer.start(randf_range(0.1,0.2))


func check_nearby_ads():
	var ads = Server.world.get_node("ads").get_children()
	for ad in ads:
		if not ad.name == self.name and not ad.character_stats.aggro_mode:
			if ad.position.distance_to(self.position) < 600:
				ad.start_aggro_mode(false)


func _physics_process(delta):
	if Server.world:
		if attacking or character_stats.destroyed:
			return
		if not character_stats.aggro_mode:
			if $detect_enemy.has_overlapping_bodies():
				start_aggro_mode(true)
		else:
			if Util.get_nearest_target($detect_enemy) and not attacking:
				attack()
		if navigation_agent.is_navigation_finished() or character_stats.destroyed:
			velocity = velocity.move_toward(Vector2.ZERO,character_stats.friction*delta)
		else:
			set_direction()
			var target = navigation_agent.get_next_path_position()
			var move_direction = position.direction_to(target)
			var desired_velocity = move_direction * character_stats.max_speed
			var steering = (desired_velocity - velocity) * delta * 4.0
			velocity += steering
		set_sprite_state()
		move_and_slide()


func attack():
	if not attacking:
		attacking = true
		sprite.play("attack")
		$hitbox/CollisionShape2D.set_deferred("disabled",false)
		await sprite.animation_finished
		$hitbox/CollisionShape2D.set_deferred("disabled",true)
		attacking = false


func set_sprite_state():
	if attacking or character_stats.destroyed:
		return
#	if character_stats.destroyed:
#		$AnimatedSprite2D.play("death")
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
	if not character_stats.destroyed:
		character_stats.destroyed = true
		await get_tree().process_frame
		sprite.play("death")
		await sprite.animation_finished
		InstancedScenes.init_item_drop(position,false)
		var tween = get_tree().create_tween()
		tween.tween_property(sprite,"modulate:a",0.0,0.5)
		await tween.finished
		call_deferred("queue_free")


func _on_timer_timeout():
	calculate_path()


func calculate_path():
	if not character_stats.aggro_mode:
		$ad_navigation_agent/Timer.start(randf_range(3.0,8.0))
		navigation_agent.set_target_position(Util.return_random_idle_position(spawn_position))
	else:
		navigation_agent.set_target_position(Server.player_node.global_position)


#
#	if $hitbox/CollisionShape2D.disabled:
#		$hitbox/CollisionShape2D.set_deferred("disabled", false)
#	else:
#		$hitbox/CollisionShape2D.set_deferred("disabled", true)
	
