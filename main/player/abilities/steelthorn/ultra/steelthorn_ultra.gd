extends Node2D


func _ready():
	$AnimatedSprite2D.play("default")
	await $AnimatedSprite2D.animation_finished
	await get_tree().create_timer(3.0).timeout
	$AnimatedSprite2D.play_backwards("default")
	await $AnimatedSprite2D.animation_finished
	call_deferred("queue_free")
	
