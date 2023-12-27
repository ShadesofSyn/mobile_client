extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func spawn_minion():
	var minion = preload("res://main/world/npcs/ghoul2/ghoul_2.tscn").instantiate()
	minion.position = self.position
	Server.world.get_node("ads").call_deferred("add_child",minion)
