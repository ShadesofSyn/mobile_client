extends Area2D


func _ready():
	await get_tree().process_frame
	var team_color = get_parent().character_stats.team_color
	if name == "detect_enemy":
		init_detect_enemy(team_color)
	else:
		init_detect_ally(team_color)


func init_detect_enemy(team_color):
	set_collision_mask(Util.return_hitbox_layer(team_color))


func init_detect_ally(team_color):
	set_collision_mask(Util.return_hurtbox_layer(team_color))
