extends Node2D


@onready var sprite: Sprite2D = $Sprite2D

var distance_to_hide_grass: float = 160.0


func _process(delta):
	if near_player():
		set_grass_invisible(delta)
	else:
		set_grass_visible(delta)


func set_grass_visible(_delta):
	sprite.modulate.a = lerp(sprite.modulate.a,1.0,_delta*3)
	
func set_grass_invisible(_delta):
	sprite.modulate.a = lerp(sprite.modulate.a,0.2,_delta*3)
	
	
func near_player() -> bool:
	if self.position.distance_to(Server.player_node.position) < distance_to_hide_grass:
		return true
	return false
