extends Node2D

var d := 0.0
var orbit_speed = 5
var orbit_radius = 400

var got_to_start_point: bool = false

var team_color = "blue"

var destroyed: bool = false


func _ready():
	
	var collision_layer_value = Util.return_hitbox_layer(team_color)
	if team_color == "red":
		$hitbox.set_collision_layer(collision_layer_value)
	else:
		$hitbox.set_collision_layer(collision_layer_value)
	randomize()
	d = randi_range(0,2.0)


func _physics_process(delta):
	if get_parent().character_stats.destroyed: 
		destroy()
		return
	
	d += delta
	var target = Vector2(sin(d*orbit_speed)*orbit_radius,cos(d*orbit_speed)*orbit_radius)
#	$first.position = lerp($first.position,target,delta*2.0)
#	$second.position = lerp($second.position,-target,delta*2.0)


func destroy() -> void:
	if not destroyed:
		destroyed = true
		set_physics_process(false)
		hide()
		call_deferred("queue_free")


func _on_timer_timeout():
	destroy()


func _on_hit_timeout():
	$hitbox/CollisionShape2D.set_deferred("disabled",false)
	await get_tree().create_timer(0.1).timeout
	$hitbox/CollisionShape2D.set_deferred("disabled",true)
