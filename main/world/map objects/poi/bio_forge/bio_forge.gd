extends CharacterBody2D

@onready var hurtbox: CollisionShape2D = $hurtbox/CollisionShape2D
@onready var sprite: Node2D = $sprites
@onready var character_stats: Node = $character_stats

func _ready():
	character_stats.team_color = "red"
	character_stats.character_name = "bio-forge"
	position = Vector2(-Constants.SIZE_OF_HEXAGON/3.46,-Constants.SIZE_OF_HEXAGON/2)


func spawn_minion():
	var minion = preload("res://main/world/npcs/minion/minion.tscn").instantiate()
	minion.position = self.position + Vector2(randf_range(-200,200),randf_range(-200,200))
	Server.world.get_node("ads").call_deferred("add_child",minion)
	if character_stats.aggro_mode:
		minion.character_stats.aggro_mode = true


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
	InstancedScenes.init_item_drop(position,true)
	call_deferred("queue_free")
