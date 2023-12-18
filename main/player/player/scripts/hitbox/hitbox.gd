extends Area2D

@export var hitbox_character_name: String = ""
@export var hitbox_attack_type: String = ""

var knockback_vector: Vector2 = Vector2.ZERO


func destroy():
	if not get_parent().character_stats.character_name == "ghoul":
		get_parent().destroy()
