extends Node2D


var team_color: String


func _ready():
	$hitbox.set_collision_layer(Util.return_hitbox_layer(team_color))
	$AnimationPlayer.play("anim")
	await $AnimationPlayer.animation_finished
	call_deferred("queue_free")
