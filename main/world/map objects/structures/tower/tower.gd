extends CharacterBody2D

@onready var hurtbox: CollisionShape2D = $hurtbox/CollisionShape2D
@onready var sprite: Node2D = $sprites
@onready var character_stats: Node = $character_stats

var attacking: bool = false

var dropped: bool = true
var team_color: String = "red"

func _ready():
	character_stats.team_color = team_color
	character_stats.character_name = "tower"
	position = Vector2(Constants.SIZE_OF_HEXAGON/3.46,Constants.SIZE_OF_HEXAGON/2)
	if team_color == "red": # Objective
		init(false)


func init(spawn_at_player):
	if spawn_at_player:
		position = Server.player_node.position
	if not $Area2D.has_overlapping_bodies():
		dropped = true
		$indicator.hide()
		$StaticBody2D/CollisionShape2D.set_deferred("disabled",false)
		$hurtbox/CollisionShape2D.set_deferred("disabled",false)
	else:
		call_deferred("queue_free")


func _physics_process(delta):
	if not dropped:
		if $Area2D.has_overlapping_bodies():
			$indicator.texture = preload("res://assets/images/misc/red_square.png")
		else:
			$indicator.texture = preload("res://assets/images/misc/green_square.png")
		position = get_global_mouse_position()
	elif $detect_enemy.has_overlapping_bodies():
		var target = Util.get_nearest_target($detect_enemy)
		$line_of_sight.look_at(target.position)
		if not attacking:
			attack()



func attack():
	attacking = true
	spawn_projectile()
	await get_tree().create_timer(Constants.structure_data["tower"]["basic"]["attackSpeed"]).timeout
	attacking = false


func spawn_projectile():
	var proj = preload("res://main/world/map objects/structures/tower/tower_projectile.tscn").instantiate()
	proj.team_color = character_stats.team_color
	proj.position = $line_of_sight/Marker2D.global_position
	proj.velocity = ($line_of_sight/Marker2D.global_position - $line_of_sight.global_position).normalized()
	Server.world.projectiles.call_deferred("add_child",proj)


func destroy():
	call_deferred("queue_free")
