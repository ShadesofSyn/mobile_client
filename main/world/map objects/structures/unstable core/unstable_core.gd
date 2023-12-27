extends CharacterBody2D

@onready var hurtbox: CollisionShape2D = $hurtbox/CollisionShape2D
@onready var sprite: Sprite2D = $base
@onready var character_stats: Node = $character_stats


func _ready():
	$hitbox.set_collision_layer(Util.return_hitbox_layer("red"))
	character_stats.team_color = "red"
	character_stats.character_name = "unstable core"
	position = Vector2(-Constants.SIZE_OF_HEXAGON/2,0)



func destroy():
	sprite.hide()
	$CPUParticles2D.emitting = true
	$hitbox/CollisionShape2D.set_deferred("disabled",false)
	await get_tree().create_timer(1.0).timeout
	call_deferred("queue_free")
