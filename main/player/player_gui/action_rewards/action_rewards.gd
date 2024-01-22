extends Control

@onready var tower_sprite = $VBoxContainer/first/icon
@onready var bio_forge_sprite = $VBoxContainer/second/icon

var dist_to_btn = 128.0

var current_tower = null

var start_press = 0
var end_press = 0


func _on_first_gui_input(event):
	if event is InputEventScreenTouch:
		if $VBoxContainer/first/icon.visible:
			if event.pressed:
#				time_start = OS.get_unix_time()
				start_press = event.position
				var turret = load("res://main/world/map objects/structures/tower/tower.tscn").instantiate()
				turret.dropped = false
				turret.team_color = "blue"
				Server.world.get_node("towers").call_deferred("add_child",turret)
				current_tower = turret
			else:
				end_press = event.position
				if start_press.distance_to(end_press) < 100:
					current_tower.init(true)
				else:
					current_tower.init(false)


func _on_second_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			var turret = load("res://main/world/map objects/poi/bio_forge/bio_forge.tscn").instantiate()
			turret.dropped = false
			turret.team_color = "blue"
			Server.world.get_node("towers").call_deferred("add_child",turret)
			current_tower = turret
		else:
			end_press = event.position
			if start_press.distance_to(end_press) < 100:
				current_tower.init(true)
			else:
				current_tower.init(false)

func remove_object_from_gui(_name_of_object):
	$VBoxContainer/first/icon.hide()
	await get_tree().create_timer(5.0).timeout
	$VBoxContainer/first/icon.show()
	
