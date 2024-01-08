extends Node2D

@onready var aim_target: Sprite2D = $aim_box
@onready var line: Line2D = $Line2D

var max_points = 250

var radius = 32

var start_pt: Vector2 = Vector2.ZERO 
var end_pt: Vector2 = Vector2(1920,1080) / 2

var max_height: float = 700.0
#var min_height: float = 500.0

var strength: float = 0
var max_strength: float = 1000.0
var strength_coefficient: float = 0.0

var path = []

var camera_zoom = 1.0



func _physics_process(delta):
#	aim_target.scale.x *= 2
	aim_target.scale = Vector2(2,1) * (radius/32)
	aim_target.position = end_pt
	strength = start_pt.distance_to(end_pt) #*1.5
	var strength_coefficient = (strength / max_strength)
	$Path2D.curve.clear_points()
	$Path2D.curve.add_point(start_pt,Vector2.ZERO,Vector2((end_pt.x-start_pt.x)/3,-max_height*strength_coefficient))
	$Path2D.curve.add_point(end_pt,Vector2(-(end_pt.x-start_pt.x)/3,-max_height*strength_coefficient))#,Vector2.ZERO)
	line.points = $Path2D.curve.get_baked_points()  
	path = $Path2D.curve.get_baked_points()  
	#print(end_pt)


