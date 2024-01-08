extends Area2D

@export var hitbox_character_name: String = ""
@export var hitbox_attack_type: String = ""

var knockback_vector: Vector2 = Vector2.ZERO


func destroy():
#	pass
#	if not get_parent().character_stats.TYPE == Constants.character_type.AD:
	if not hitbox_character_name == "ghoul" and not hitbox_character_name == "golem":
		get_parent().destroy()
