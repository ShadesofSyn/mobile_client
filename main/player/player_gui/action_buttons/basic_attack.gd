extends TextureRect

var cooldown: bool = false
var being_pressed: bool = false
const dist_to_btn: float = 0.0

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _is_point_inside_button_area(event.position) and not cooldown:
				cooldown = true
				being_pressed = true
				attack()
			else:
				being_pressed = false
		else:
			being_pressed = false

func attack():
	Server.player_node.sprite.attack()
	await get_tree().create_timer(0.5).timeout
	cooldown = false
	if being_pressed:
		attack()

func _physics_process(delta):
	if being_pressed:
		set_btn_pressed(delta)
	else:
		set_btn_normal(delta)


func _is_point_inside_button_area(point:Vector2) -> bool:
	var x: bool = point.x >= global_position.x+dist_to_btn and point.x <= global_position.x - dist_to_btn + (size.x * get_global_transform_with_canvas().get_scale().x)
	var y: bool = point.y >= global_position.y+dist_to_btn and point.y <= global_position.y - dist_to_btn + (size.y * get_global_transform_with_canvas().get_scale().y)
	return x and y



func set_btn_pressed(delta) -> void:
	self.scale = lerp(self.scale,Vector2(0.95,0.95),delta*5)
	
	
func set_btn_normal(delta) -> void:
	self.scale = lerp(self.scale,Vector2(1.0,1.0),delta*5)
