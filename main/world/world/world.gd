extends Node2D

@onready var projectiles = $projectiles
@onready var valid_tiles:TileMap = $map/valid_tiles
@onready var tall_grass_tiles: TileMap = $map/grass
@onready var wall_tiles: TileMap = $map/walls
@onready var boundary_area: CollisionPolygon2D = $boundary/CollisionPolygon2D


func _ready():
	set_spawn_area_points_and_size()
	set_size_of_polygon()
#	init_tall_grass()
	await get_tree().process_frame
	Server.world = self


func set_spawn_area_points_and_size() -> void:
	await get_tree().process_frame
	for i in range(6):
		get_node("spawn_areas/"+str(i+1)).position = boundary_area.polygon[5-i]
		get_node("spawn_areas/"+str(i+1)).queue_redraw()


func set_size_of_polygon() -> void:
#	var points: PackedVector2Array
#	points.append(Vector2(0,hex_size)) # going clockwise
#	points.append(Vector2(hex_size*HEX_OFFSET,hex_size*0.5))
#	points.append(Vector2(hex_size*HEX_OFFSET,-hex_size*0.5))
#	points.append(Vector2(0,-hex_size))
#	points.append(Vector2(-hex_size*HEX_OFFSET,-hex_size*0.5))
#	points.append(Vector2(-hex_size*HEX_OFFSET,hex_size*0.5))
#	boundary_area.set_polygon(points)
#	points.append(Vector2(0,hex_size))
#	$lines/border.points = points
#	print(Vector2(hex_size/3.46,hex_size/2))
	get_node("objectives/scrying_orbs/1").position.x = -Constants.SCRYING_ORB_DISTANCE_TO_CENTER
	get_node("objectives/scrying_orbs/2").position.x = Constants.SCRYING_ORB_DISTANCE_TO_CENTER
	get_node("objectives/objectives/1").position = Vector2(-Constants.SIZE_OF_HEXAGON/3.46,Constants.SIZE_OF_HEXAGON/2)
	get_node("objectives/objectives/2").position = Vector2(Constants.SIZE_OF_HEXAGON/3.46,Constants.SIZE_OF_HEXAGON/2)
	get_node("objectives/objectives/3").position = Vector2(-Constants.SIZE_OF_HEXAGON/3.46,-Constants.SIZE_OF_HEXAGON/2)
	get_node("objectives/objectives/4").position = Vector2(Constants.SIZE_OF_HEXAGON/3.46,-Constants.SIZE_OF_HEXAGON/2)
	get_node("objectives/objectives/5").position = Vector2(-Constants.SIZE_OF_HEXAGON/1.73,0)
	get_node("objectives/objectives/6").position = Vector2(Constants.SIZE_OF_HEXAGON/1.73,0)


#func set_lines() -> void:
#	for i in range(6):
#		get_node("lines/"+str(i+1)).points = [Vector2(0,hex_size),Vector2(0,0)]
#	get_node("lines/quad_lines/2").position = Vector2(0,hex_size)
#	get_node("lines/quad_lines/3").position = Vector2(-hex_size*HEX_OFFSET,hex_size/2)
#	for i in range(3):
#		get_node("lines/quad_lines/"+str(i+1)).points = [Vector2(0,0),Vector2(0,hex_size/pow(3, 1/2.0))]
#	get_node("objectives/objectives/1").position = Vector2(-hex_size/3.46,hex_size/2)
#	get_node("objectives/objectives/2").position = Vector2(hex_size/3.46,hex_size/2)
#	get_node("objectives/objectives/3").position = Vector2(-hex_size/3.46,-hex_size/2)
#	get_node("objectives/objectives/4").position = Vector2(hex_size/3.46,-hex_size/2)
#	get_node("objectives/objectives/5").position = Vector2(-hex_size/1.73,0)
#	get_node("objectives/objectives/6").position = Vector2(hex_size/1.73,0)

func init_tall_grass() -> void:
	for loc in tall_grass_tiles.get_used_cells(0):
		var grass = preload("res://main/world/map objects/obstacles/tall_grass/tall_grass.tscn").instantiate()
		grass.position = loc*80 + Vector2i(40,40)
		$obstacles.add_child(grass)
#		valid_tiles.set_cell(0,loc,0,Vector2i(1,0))
	tall_grass_tiles.hide()


