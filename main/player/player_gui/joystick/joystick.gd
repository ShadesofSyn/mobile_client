extends Control

## A simple virtual joystick for touchscreens, with useful options.
## Github: https://github.com/MarcoFazioRandom/Virtual-Joystick-Godot

# EXPORTED VARIABLE

## The color of the button when the joystick is pressed.
@export var pressed_color := Color.GRAY

## If the input is inside this range, the output is zero.
@export_range(0, 200, 1) var deadzone_size : float = 15

## The max distance the tip can reach.
@export_range(0, 500, 1) var clampzone_size : float = 90

enum Joystick_mode {
	FIXED, ## The joystick doesn't move.
	DYNAMIC, ## Every time the joystick area is pressed, the joystick position is set on the touched position.
}

## If the joystick stays in the same position or appears on the touched position when touch is started
@export var joystick_mode := Joystick_mode.FIXED


## If the joystick tip should slide to touch position
@export var slide_joystick_mode: bool = false
@export var max_speed: float = 1.5


enum Visibility_mode {
	ALWAYS, ## Always visible
	TOUCHSCREEN_ONLY ## Visible on touch screens only
}

## If the joystick is always visible, or is shown only if there is a touchscreen
@export var visibility_mode := Visibility_mode.ALWAYS

## If true, the joystick uses Input Actions (Project -> Project Settings -> Input Map)
@export var use_input_actions := true

@export var action_left := "ui_left"
@export var action_right := "ui_right"
@export var action_up := "ui_up"
@export var action_down := "ui_down"

# PUBLIC VARIABLES

## If the joystick is receiving inputs.
var is_pressed := false

var output := Vector2.ZERO

var _touch_index : int = -1

@onready var _base := $base
@onready var _tip := $base/tip

@onready var _base_radius = _base.size * _base.get_global_transform_with_canvas().get_scale() / 2

@onready var _base_default_position : Vector2 = _base.position
@onready var _tip_default_position : Vector2 = _tip.position

@onready var _default_color : Color = _tip.modulate

var posVector: Vector2 = Vector2.ZERO
var strength_coefficient: float = 0.0

var screen_touch_position: Vector2 = Vector2.ZERO
var tween

var start_pos: Vector2

var movement_joystick: bool = false
var cooldown_active: bool = false


func _ready() -> void:
#	start_pos = $CharacterBody2D.position
	if not DisplayServer.is_touchscreen_available() and visibility_mode == Visibility_mode.TOUCHSCREEN_ONLY:
		hide()
	_reset()
	set_joystick_type()
	
#	$Base/Tip/icon.hide()
#	set_joystick_type(1)
#	if name.right(1) == "1":
#		init()

#func init():
##	_base.self_modulate.a = 1.0
#	$Base/Tip/icon.show()
#	_reset()


func set_joystick_type():
	await get_tree().process_frame
	if name == "movement_joystick":
		movement_joystick = true
		modulate.a = 0.5
	else:
		_base.self_modulate.a = 0.0


func set_as_attack_joystick():
#	_tip.scale = Vector2(1.0,1.0)
	joystick_mode = Joystick_mode.DYNAMIC
	modulate.a = 0.15
	_base.self_modulate.a = 0.0
	_tip.self_modulate.a = 1.0

#func set_as_button_mode():
#	_tip.scale = Vector2(1.9,1.9)
#	joystick_mode = Joystick_mode.BUTTON
#	modulate.a = 1.0
#	_base.self_modulate.a = 0.0



var joy_btn_pressed: bool = false


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if _is_point_inside_button_area(event.position) and _touch_index == -1 and not movement_joystick and not cooldown_active:
				if joystick_mode == Joystick_mode.DYNAMIC or (joystick_mode == Joystick_mode.FIXED and _is_point_inside_base(event.position)):
					joystick_pressed(event)
			elif _is_point_inside_joystick_area(event.position) and _touch_index == -1 and movement_joystick:
				if joystick_mode == Joystick_mode.DYNAMIC or (joystick_mode == Joystick_mode.FIXED and _is_point_inside_base(event.position)):
					joystick_pressed(event)
		elif event.index == _touch_index:
			_reset()
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag:
		if event.index == _touch_index:
			_update_joystick(event.position)
			get_viewport().set_input_as_handled()

func joystick_pressed(_event):
	if joystick_mode == Joystick_mode.DYNAMIC:
		_move_base(_event.position)
	_touch_index = _event.index
	_tip.modulate = pressed_color
	_update_joystick(_event.position)
	get_viewport().set_input_as_handled()

func _move_base(new_position: Vector2) -> void:
	_base.global_position = new_position - _base.pivot_offset * get_global_transform_with_canvas().get_scale()

func _move_tip(new_position: Vector2) -> void:
	_tip.global_position = new_position - _tip.pivot_offset * _base.get_global_transform_with_canvas().get_scale()


func _is_point_inside_joystick_area(point: Vector2) -> bool:
	var x: bool = point.x >= global_position.x and point.x <= global_position.x + (size.x * get_global_transform_with_canvas().get_scale().x)
	var y: bool = point.y >= global_position.y and point.y <= global_position.y + (size.y * get_global_transform_with_canvas().get_scale().y)
	return x and y
	
func _is_point_inside_button_area(point: Vector2) -> bool:
	var x: bool = point.x >= _tip.global_position.x and point.x <= _tip.global_position.x + (_tip.size.x * get_global_transform_with_canvas().get_scale().x)
	var y: bool = point.y >= _tip.global_position.y and point.y <= _tip.global_position.y + (_tip.size.y * get_global_transform_with_canvas().get_scale().y)
	return x and y

func _is_point_inside_base(point: Vector2) -> bool:
	var center : Vector2 = _base.global_position + _base_radius
	var vector : Vector2 = point - center
	if vector.length_squared() <= _base_radius.x * _base_radius.x:
		return true
	else:
		return false

func _update_joystick(touch_position: Vector2) -> void:
	
	screen_touch_position = touch_position
	
	var center : Vector2 = _base.global_position + _base_radius
	var vector : Vector2 = touch_position - center
	vector = vector.limit_length(clampzone_size)
	
	strength_coefficient = vector.length()/clampzone_size
	
	_move_tip(center + vector)
	
	if vector.length_squared() > deadzone_size * deadzone_size:
		posVector = vector
		is_pressed = true
		output = (vector - (vector.normalized() * deadzone_size)) / (clampzone_size - deadzone_size)
		if tween:
			tween.kill()
		modulate.a =  1.0
		_tip.self_modulate.a = 1.0
		_base.self_modulate.a = 1.0
	else:
		posVector = Vector2.ZERO
		is_pressed = false
		output = Vector2.ZERO
		if tween:
			tween.kill()
		modulate.a =  0.15
		_tip.self_modulate.a = 1.0
		_base.self_modulate.a = 1.0
	
	if use_input_actions:
		if output.x > 0:
			_update_input_action(action_right, output.x)
		else:
			_update_input_action(action_left, -output.x)

		if output.y > 0:
			_update_input_action(action_down, output.y)
		else:
			_update_input_action(action_up, -output.y)


func _physics_process(delta):
	if name == "movement_joystick":
		if not is_pressed:
			output = get_input_vector()
		if slide_joystick_mode and is_pressed:
			var center : Vector2 = _base.global_position + _base_radius
			var vector : Vector2 = screen_touch_position - center
			if vector.length() >= clampzone_size+60:
				slide_joystick(delta,vector,screen_touch_position)
	else:
		return
		if $cooldown.time_left == 0.0:
			$Base/Tip/time_remaing.hide()
			$Base/Tip/icon.show()
		else:
			$Base/Tip/icon.hide()
			$Base/Tip/time_remaing.show()
			$Base/Tip/time_remaing.text = str(snapped($cooldown.time_left,0.1))


func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	var center : Vector2 = _base.global_position + _base_radius
	var vector : Vector2 =  input_vector
	vector = vector.limit_length(clampzone_size)
	strength_coefficient = vector.length()/clampzone_size
	if not input_vector == Vector2.ZERO:
		modulate.a =  1.0
		_tip.self_modulate.a = 1.0
		_base.self_modulate.a = 1.0
	else:
		modulate.a =  0.1
		_tip.self_modulate.a = 1.0
		_base.self_modulate.a = 1.0
	_move_tip(center + vector.normalized()*clampzone_size)
	return input_vector.normalized()



func slide_joystick(delta,vector,touch_position): 
	var base_target = _base.global_position+ _base.pivot_offset
	var tip_target = _tip.global_position+_tip.pivot_offset
	var dist = base_target.distance_to(tip_target)
	var knob_pos = _base.global_position - _base.pivot_offset
	_base.global_position = lerp(base_target, base_target+(vector/2), delta * max_speed)- _base.pivot_offset




func _update_input_action(action:String, value:float):
	if value > InputMap.action_get_deadzone(action):
		Input.action_press(action, value)
	elif Input.is_action_pressed(action):
		Input.action_release(action)

func _reset():
	if tween:
		tween.kill() 
	check_if_shoot_projectile()
	strength_coefficient = 0
	modulate.a =  0.0
	posVector = Vector2.ZERO
	is_pressed = false
	output = Vector2.ZERO
	_touch_index = -1
	_tip.modulate = _default_color
	_base.position = _base_default_position
	_tip.position = _tip_default_position
	if use_input_actions:
		for action in [action_left, action_right, action_down, action_up]:
			if Input.is_action_pressed(action) or Input.is_action_just_pressed(action):
				Input.action_release(action)
	await get_tree().create_timer(0.2).timeout
	if _tip.position == _tip_default_position:
		modulate.a =  1.0
		_tip.self_modulate.a = 0.0
		_base.self_modulate.a = 0.0
		if tween:
			tween.kill() 
		tween = get_tree().create_tween()
		tween.parallel().tween_property(_tip,"self_modulate:a",0.15,0.2)
		if movement_joystick:
			tween.parallel().tween_property(_base,"self_modulate:a",0.15,0.4)


func check_if_shoot_projectile():
	if not movement_joystick:
		if is_pressed and not cooldown_active:
			cooldown_active = true
			$cooldown_timer.start(10)
			modulate.g = 0.0
			modulate.b = 0.0
			var char
			match name.right(1):
				"1":
					char = Server.player_node
				"2":
					char = Server.ally_node1
				"3":
					char = Server.ally_node2
			char.ultra_attack(output)


func _on_cooldown_timer_timeout():
	cooldown_active = false
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self,"modulate:g",1.0,0.25)
	tween.parallel().tween_property(self,"modulate:b",1.0,0.25)
