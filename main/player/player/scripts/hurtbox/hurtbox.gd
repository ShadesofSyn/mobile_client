extends Area2D

@onready var progress_bar: TextureProgressBar = $TextureProgressBar

var current_health: int

func _ready():
	await get_tree().process_frame
	if get_parent().character_stats:
		set_hurtbox_stats()
		set_team_stats(get_parent().character_stats.team_color)
	else:
		printerr("INVALID HURTBOX SETUP")


func set_hurtbox_stats() -> void:
	progress_bar.max_value = Constants.character_data[get_parent().character_stats.character_name]["baseStats"]["health"]
	current_health = progress_bar.max_value
	progress_bar.value = progress_bar.max_value


func set_team_stats(_team_color) -> void:
	set_collision_mask(Util.return_hurtbox_layer(_team_color))
	match _team_color:
		"blue":
			$Label.modulate = Color("00dbff")
		"red":
			$Label.modulate = Color("ff4961")
		"white":
			$Label.modulate = Color("ffffff")
	


func _on_area_entered(area):
	pass # Replace with function body.
