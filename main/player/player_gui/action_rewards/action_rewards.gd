extends Control

var dist_to_btn = 128.0

var current_tower = null

func _on_first_gui_input(event):
	if event is InputEventScreenTouch:
		if $VBoxContainer/first/icon.visible:
			if event.pressed:
				var turret = load("res://main/world/map objects/structures/tower/tower.tscn").instantiate()
				Server.world.get_node("towers").call_deferred("add_child",turret)
				current_tower = turret
			else:
				current_tower.init()


func _on_second_gui_input(event):
	return
	if event is InputEventScreenTouch:
		if event.pressed:
			var turret = load("res://main/towers/bio_forge.tscn").instantiate()
			Server.world.get_node("towers").call_deferred("add_child",turret)
			current_tower = turret
		else:
			current_tower.init()

func remove_object_from_gui(_name_of_object):
	$VBoxContainer/first/icon.hide()
	await get_tree().create_timer(5.0).timeout
	$VBoxContainer/first/icon.show()
	
