extends CharacterBody2D

@onready var hurtbox: CollisionShape2D = $hurtbox/CollisionShape2D
@onready var character_stats = $character_stats
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var navigation_agent: NavigationAgent2D = $ad_navigation_agent

@export var MAX_SPEED = 100
@export var ACCELERATION = 50


var team_color: String
var anchor_mode: bool = false
var spawn_position: Vector2
var attacking: bool = false


func _ready():
	$hitbox.set_collision_layer(Util.return_hitbox_layer("red"))
	character_stats.team_color = "red"
	character_stats.character_name = "tree"
	character_stats.TYPE = Constants.character_type.BEAST
	position = Vector2(-Constants.SIZE_OF_HEXAGON/2,0)


func _physics_process(delta):
	if character_stats.destroyed:
		$hitbox/CollisionShape2D.set_deferred("disabled",true)
		return
	set_direction()
	if $detect_enemy.has_overlapping_bodies():
		var target = Util.get_nearest_target($detect_enemy)
		$line_of_sight.look_at(target.position)
		if not attacking:
			attack()


func set_direction():
	if Server.player_node:
		if Server.player_node.position.x > self.position.x:
			sprite.position.x = 140
			sprite.flip_h = false
		else:
			sprite.position.x = -140
			sprite.flip_h = true
	

func attack():
	attacking = true
	init_hitbox()
	if Util.chance(50):
		Server.player_node.root_lock()
	await get_tree().create_timer(Constants.beast_data["tree"]["basic"]["attackSpeed"]*3).timeout
	attacking = false


func init_hitbox():
	$AnimatedSprite2D.play("attack")
	$hitbox/CollisionShape2D.set_deferred("disabled",false)
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("idle")
	$hitbox/CollisionShape2D.set_deferred("disabled",true)
	
func destroy():
	character_stats.destroyed = true
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	call_deferred("queue_free")
