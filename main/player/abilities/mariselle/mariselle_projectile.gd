extends CharacterBody2D


var speed = 1300
var destroyed = false
var team_color: String


func _ready():
	$hitbox.set_collision_layer(Util.return_hitbox_layer(team_color))
	rotation_degrees = rad_to_deg(Vector2(1,0).angle_to(velocity))


func _physics_process(delta):
	if destroyed:
		return

#	if $hitbox.has_overlapping_bodies():
#		destroy()
	var collision_info = move_and_collide(velocity * delta * speed)


func destroy():
	destroyed = true
	hide()
	call_deferred("queue_free")
