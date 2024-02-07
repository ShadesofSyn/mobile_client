extends CharacterBody2D

@onready var hurtbox: CollisionShape2D = $hurtbox/CollisionShape2D
@onready var sprite: Node2D = $sprites
@onready var character_stats: Node = $character_stats

var team_color: String = "red"
var dropped: bool = true

func _ready():
	character_stats.team_color = team_color
	character_stats.character_name = "bio-forge"
	position = Vector2(-Constants.SIZE_OF_HEXAGON/3.46,-Constants.SIZE_OF_HEXAGON/2)
	if team_color == "red": # Objective
		init(false)


func spawn_minion():
	var minion = preload("res://main/world/npcs/minion/minion.tscn").instantiate()
	minion.team_color = team_color
	minion.position = self.position + Vector2(randf_range(-200,200),randf_range(-200,200))
	Server.world.get_node("ads").call_deferred("add_child",minion)
	if character_stats.aggro_mode:
		minion.character_stats.aggro_mode = true


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


func start_aggro_mode(is_first_ad):
	character_stats.aggro_mode = true


func _on_timer_timeout():
	var ads = Server.world.get_node("ads").get_children()
	$AnimationPlayer.play("animate")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play_backwards("animate")
	await $AnimationPlayer.animation_finished
	if ads.size() < 15:
		spawn_minion()


func destroy():
	InstancedScenes.init_item_drop(position,true,"bio-forge")
	call_deferred("queue_free")
