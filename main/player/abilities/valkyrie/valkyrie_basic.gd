extends Node2D

var velocity
var team_color: String


func _ready():
	$hitbox.set_collision_layer(Util.return_hitbox_layer(team_color))
	rotation_degrees = rad_to_deg(Vector2(1,0).angle_to(velocity))
	await get_tree().create_timer(0.5).timeout
	call_deferred("queue_free")
