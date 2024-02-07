extends CharacterBody2D


var speed = 1100
var destroyed = false
var team_color: String


func _ready():
	$hitbox.set_collision_layer(Util.return_hitbox_layer(team_color)+8)
	rotation_degrees = rad_to_deg(Vector2(1,0).angle_to(velocity))


func _physics_process(delta):
	if destroyed:
		velocity = Vector2.ZERO
		return

#	if $hitbox.has_overlapping_bodies():
#		destroy()
	var collision_info = move_and_collide(velocity * delta * speed)


func destroy():
	if not destroyed:
		destroyed = true
		$Sprite2D.hide()
		$hitbox/CollisionShape2D.set_deferred("disabled",true)
		$CPUParticles2D.emitting = true
		await get_tree().create_timer(0.5).timeout
		call_deferred("queue_free")


func _on_timer_timeout():
	destroy()
