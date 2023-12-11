extends Node2D

func _ready():
	play_dash()

func play_dash() -> void:

	$particles.set_deferred("emitting", true)
	$burst.set_deferred("rotation", (get_parent().velocity*-1).angle())
	$burst.call_deferred("restart")
	$burst.set_deferred("emitting", true)
	set_player_whitened()
	get_parent().character_stats.dashing = true
	$Timer.call_deferred("start")
	await get_tree().create_timer(Constants.DASH_LENGTH).timeout
	$particles.set_deferred("emitting", false)
	$burst.set_deferred("emitting", false)
	get_parent().character_stats.dashing = false
	$Timer.call_deferred("stop")
	await get_tree().create_timer(1.0).timeout
	get_parent().character_stats.dashing = false
	call_deferred("queue_free")
	
	
func set_player_whitened() -> void:
	get_parent().sprite.material.call_deferred("set_shader_parameter","flash_color",Color("ffffff"))
	get_parent().sprite.material.call_deferred("set_shader_parameter", "flash_modifier", 0.7)
	await get_tree().create_timer(0.5).timeout
	get_parent().sprite.material.call_deferred("set_shader_parameter", "flash_modifier", 0.0)

func _on_timer_timeout():
	var sprite = get_node("../sprite")
	var ghost: Sprite2D = preload("res://main/player/abilities/dash/dash_ghost.tscn").instantiate()
	ghost.pos = get_parent().global_position
	ghost.texture = sprite.texture
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.scale = sprite.scale
	ghost.position = sprite.position 
	Server.world.get_node("projectiles").call_deferred("add_child", ghost)

