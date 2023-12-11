extends Node2D


var last_saved_angle: int = 0


var frame_to_update: float = 0.0

func _physics_process(delta):
	set_los(delta)

func set_los(delta) -> void:
	var nearest_target = Util.get_nearest_target(get_node("../detect_enemy"))
	if nearest_target:
		get_node("../CollisionShape2D").look_at(nearest_target.global_position)
		rotation_degrees = lerp(self.rotation_degrees,get_node("../CollisionShape2D").rotation_degrees,delta*10)
	else:
		if not get_parent().joystick.output == Vector2.ZERO:
			var angle = rad_to_deg(Vector2(1,0).angle_to(get_parent().joystick.output))
			angle = int(round(angle))
			get_node("../CollisionShape2D").rotation_degrees = angle
			rotation_degrees = get_node("../CollisionShape2D").rotation_degrees
