extends Node2D

var team_color: String
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	$hitbox.hitbox_name = "magmaul ultra"
	set_hitbox_layer()
	play_ultra()


func set_hitbox_layer() -> void:
	$hitbox.set_collision_layer(Util.return_hitbox_layer(team_color))


func play_ultra() -> void:
	sprite.play("start")
	await sprite.animation_finished
	for i in range(3):
		sprite.play("loop")
		await sprite.animation_finished
		init_heal_hitbox()
	sprite.play_backwards("start")
	await sprite.animation_finished
	call_deferred("queue_free")
	

func init_heal_hitbox():
	$hitbox/CollisionShape2D.set_deferred("disabled",false)
	await get_tree().create_timer(0.1).timeout
	$hitbox/CollisionShape2D.set_deferred("disabled",true)
