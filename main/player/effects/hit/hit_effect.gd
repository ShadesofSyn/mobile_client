extends Node2D


var amount 



func _ready():
	$Label.text = str(abs(amount))
	if amount > 0:
		$Label.self_modulate.g = 1.0
	else:
		$Label.self_modulate.r = 1.0
	$AnimationPlayer.play("animate")
	await $AnimationPlayer.animation_finished
	call_deferred("queue_free")
