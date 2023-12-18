extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var team_color: String

func _ready():
	$hitbox.set_collision_layer(Util.return_hitbox_layer(team_color))
	play_ultra()
	
func play_ultra():
	sprite.play("start")
	await sprite.animation_finished
	for i in range(3):
		sprite.play("loop")
		await sprite.animation_finished
		enable_hitbox()
	sprite.play("end")
	await sprite.animation_finished
	call_deferred("queue_free")


func enable_hitbox():
	$hitbox/CollisionShape2D.set_deferred("disabled",false)
	await get_tree().create_timer(0.1).timeout
	$hitbox/CollisionShape2D.set_deferred("disabled",true)
