extends Control


# Called when the node enters the scene tree for the first time.
#func _ready():
#	add_active_team_boost("Invisibility",10)
#	await get_tree().create_timer(1.7).timeout
#	add_active_team_boost("Speed Boost", 10)

func add_active_team_boost(title,length):
	var label = preload("res://main/player/player_gui/active_team_boosts/boost_label.tscn").instantiate()
	label.title = title
	label.length = length
	$list.call_deferred("add_child",label)
	
