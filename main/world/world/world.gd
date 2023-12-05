extends Node2D

@onready var valid_tiles:TileMap = $map/valid_tiles
@onready var tall_grass_tiles: TileMap = $map/grass
@onready var wall_tiles: TileMap = $map/walls
@onready var boundary_area: CollisionPolygon2D = $boundary/CollisionPolygon2D

@export var hex_size: float = 5500
@export var spawn_area_radius: float = 640
@export var redraw: bool : set = redraw_map

@export var size_of_vortex: float = 480
@export var scrying_orb_distance_to_center: float = 1000

const HEX_OFFSET: float = 0.866025




func _ready():
	redraw_map(null)
	init_tall_grass()
	init_walls()
	Server.world = self




func redraw_map(value = null) -> void:
	set_size_of_polygon()
	set_lines()
	set_spawn_area_points_and_size()


func set_spawn_area_points_and_size() -> void:
	await get_tree().process_frame
	for i in range(6):
		get_node("spawn_areas/"+str(i+1)).position = boundary_area.polygon[5-i]
		get_node("spawn_areas/"+str(i+1)).queue_redraw()
	


func set_size_of_polygon() -> void:
	var points: PackedVector2Array
	points.append(Vector2(0,hex_size)) # going clockwise
	points.append(Vector2(hex_size*HEX_OFFSET,hex_size*0.5))
	points.append(Vector2(hex_size*HEX_OFFSET,-hex_size*0.5))
	points.append(Vector2(0,-hex_size))
	points.append(Vector2(-hex_size*HEX_OFFSET,-hex_size*0.5))
	points.append(Vector2(-hex_size*HEX_OFFSET,hex_size*0.5))
	boundary_area.set_polygon(points)
	points.append(Vector2(0,hex_size))
	$lines/border.points = points
	get_node("objectives/scrying_orbs/1").position.x = -scrying_orb_distance_to_center
	get_node("objectives/scrying_orbs/2").position.x = scrying_orb_distance_to_center


func set_lines() -> void:
	for i in range(6):
		get_node("lines/"+str(i+1)).points = [Vector2(0,hex_size),Vector2(0,0)]
	get_node("lines/quad_lines/2").position = Vector2(0,hex_size)
	get_node("lines/quad_lines/3").position = Vector2(-hex_size*HEX_OFFSET,hex_size/2)
	for i in range(3):
		get_node("lines/quad_lines/"+str(i+1)).points = [Vector2(0,0),Vector2(0,hex_size/pow(3, 1/2.0))]
	get_node("objectives/objectives/1").position = Vector2(-hex_size/3.46,hex_size/2)
	get_node("objectives/objectives/2").position = Vector2(hex_size/3.46,hex_size/2)
	get_node("objectives/objectives/3").position = Vector2(-hex_size/3.46,-hex_size/2)
	get_node("objectives/objectives/4").position = Vector2(hex_size/3.46,-hex_size/2)
	get_node("objectives/objectives/5").position = Vector2(-hex_size/1.73,0)
	get_node("objectives/objectives/6").position = Vector2(hex_size/1.73,0)

func init_tall_grass() -> void:
	for loc in tall_grass_tiles.get_used_cells(0):
		var grass = preload("res://main/world/map objects/obstacles/tall_grass/tall_grass.tscn").instantiate()
		grass.position = loc*80 + Vector2i(40,40)
		$obstacles.add_child(grass)
#		valid_tiles.set_cell(0,loc,0,Vector2i(1,0))
	tall_grass_tiles.hide()


func init_walls():
	for loc in $map/walls.get_used_cells(0):
		valid_tiles.erase_cell(0,loc)
#		var barrel = preload("res://main/roguelike/map objects/barrel.tscn").instantiate()
#		barrel.location = loc
#		barrel.position = loc*64 + Vector2i(32,32)
#		$walls.add_child(barrel)
#	$map/walls.hide()
