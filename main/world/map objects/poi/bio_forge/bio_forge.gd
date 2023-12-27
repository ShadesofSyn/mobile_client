extends CharacterBody2D

@onready var hurtbox: CollisionShape2D = $hurtbox/CollisionShape2D
@onready var sprite: Node2D = $sprites
@onready var character_stats: Node = $character_stats

func _ready():
	character_stats.team_color = "red"
	character_stats.character_name = "bio-forge"
	position = Vector2(Constants.SIZE_OF_HEXAGON/3.46,Constants.SIZE_OF_HEXAGON/2)


func spawn_minion():
	var minion = preload("res://main/world/npcs/ghoul2/ghoul_2.tscn").instantiate()
	minion.position = self.position + Vector2(randf_range(-200,200),randf_range(-200,200))
	Server.world.get_node("ads").call_deferred("add_child",minion)


func _on_timer_timeout():
	var ads = Server.world.get_node("ads").get_children()
	$AnimationPlayer.play("animate")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play_backwards("animate")
	await $AnimationPlayer.animation_finished
	if ads.size() < 10:
		spawn_minion()


func destroy():
	call_deferred("queue_free")
