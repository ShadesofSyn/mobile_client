extends Node2D


func _draw():
	var center = Vector2(0, 0)
	var radius = Constants.SIZE_OF_SPAWN_AREA
	var angle_from = (-2*PI) / 3 #-3*PI/4
	var angle_to = 0
	var color = Color(1.0, 1.0, 1.0)
	var width = 56
	var angle_from2 = 90 
	var angle_to2 = -30
	var color2 = Color(1.0, 1.0, 1.0,0.25)
	draw_arc(center, radius,angle_from, angle_to, width, color, 2, true)
	draw_circle_arc_poly(center, radius, angle_from2, angle_to2, color2)



func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	var colors = PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
