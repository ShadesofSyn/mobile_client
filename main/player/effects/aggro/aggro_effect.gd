extends AnimatedSprite2D



func _ready():
	play()
	await animation_finished
	call_deferred("queue_free")
