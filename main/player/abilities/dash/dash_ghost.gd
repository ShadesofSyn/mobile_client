extends Sprite2D

var pos 

func _ready():
	position = pos + Vector2(0,-64)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.25)
	await get_tree().create_timer(0.5).timeout 
	call_deferred("queue_free")
