extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var direction: String = "e"
var aim_vector: Vector2

const directions = [  
		"N", 
		"NE",
		"E", 
		"SE",
		"S",
		"SW",
		"W",
		"NW"]

func _ready():
	var angle = rad_to_deg(Vector2(1,0).angle_to(aim_vector))+90
	set_direction_from_angle(angle)
	sprite.texture = load("res://assets/characters/steelthorn/ultra/Steelthorn-ultra-"+direction+"-01.png")
	await get_tree().create_timer(0.125).timeout
	sprite.texture = load("res://assets/characters/steelthorn/ultra/Steelthorn-ultra-"+direction+"-02.png")
	await get_tree().create_timer(0.125).timeout
	sprite.texture = load("res://assets/characters/steelthorn/ultra/Steelthorn-ultra-"+direction+"-03.png")
	await get_tree().create_timer(0.125).timeout
	sprite.texture = load("res://assets/characters/steelthorn/ultra/Steelthorn-ultra-"+direction+"-04.png")
	await get_tree().create_timer(0.125).timeout
	sprite.texture = load("res://assets/characters/steelthorn/ultra/Steelthorn-ultra-"+direction+"-05.png")
	await get_tree().create_timer(3.0).timeout
	sprite.texture = load("res://assets/characters/steelthorn/ultra/Steelthorn-ultra-"+direction+"-04.png")
	await get_tree().create_timer(0.125).timeout
	sprite.texture = load("res://assets/characters/steelthorn/ultra/Steelthorn-ultra-"+direction+"-03.png")
	await get_tree().create_timer(0.125).timeout
	sprite.texture = load("res://assets/characters/steelthorn/ultra/Steelthorn-ultra-"+direction+"-02.png")
	await get_tree().create_timer(0.125).timeout
	sprite.texture = load("res://assets/characters/steelthorn/ultra/Steelthorn-ultra-"+direction+"-01.png")
	call_deferred("queue_free")
	

func set_direction_from_angle(angle) -> void:
	if angle < 0:
		angle = angle + 360
	var desired_direction_index = int((angle/45)+.5)
	if desired_direction_index == 8:
		desired_direction_index = 0
	direction = directions[desired_direction_index].to_lower()
	if direction == "w":
		position -= Vector2(300,100)
	elif not direction == "e":
		position -= Vector2(150,100)
	else:
		position -= Vector2(0,100)
