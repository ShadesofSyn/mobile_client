extends AnimatedSprite2D


func _ready():
	play("default")
	await get_tree().create_timer(2.0).timeout
	play_backwards("default")
	await self.animation_finished
	Server.player_node.character_stats.stunned = false
	call_deferred("queue_free")
