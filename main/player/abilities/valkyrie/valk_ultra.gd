extends Node2D

var d := 0.0
var orbit_speed = 5
var orbit_radius = 240

var got_to_start_point: bool = false

var team_color = "blue"

func _ready():
#	$hitbox.hitbox_name = "valkyrie ultimate"
#	if team_color == "red":
#		$hitbox.set_collision_layer(2+16)
#	else:
#		$hitbox.set_collision_layer(1+8)
	randomize()
	d = randi_range(0,2.0)


func _physics_process(delta):
	if get_parent().stats.destroyed: return
	
	d += delta
	var target = Vector2(sin(d*orbit_speed)*orbit_radius,cos(d*orbit_speed)*orbit_radius)
	position = lerp(position,target,delta*5.0)


func _on_timer_timeout():
	set_physics_process(false)
	hide()
	call_deferred("queue_free")
