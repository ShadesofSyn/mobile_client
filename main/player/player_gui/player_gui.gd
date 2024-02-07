extends CanvasLayer

var lockstep_pressed: bool = false


@onready var attack_joystick1 = $action_buttons/attack_joystick1
@onready var attack_joystick2 = $action_buttons/attack_joystick2
@onready var attack_joystick3 = $action_buttons/attack_joystick3

var tween
var active_projectile = null
var amt_gold: int = 0

@export var ability_index: int = 2

var attacking: bool = false

func _ready():
	show()
	
	
func set_action_reward(type):
	if type == "bio-forge":
		$action_rewards.bio_forge_sprite.show()
	else:
		$action_rewards.tower_sprite.show()
		


func set_active_joysticks(new_index):
	ability_index = new_index
	for i in range(2):
		get_node("bottom_right/attack_joystick"+str(i+1)).set_joystick_type(new_index)


func _physics_process(delta):
	if not attack_joystick1.is_pressed and not attack_joystick2.is_pressed and not attack_joystick3.is_pressed:
		remove_lobbed_projectile_line()
	elif attack_joystick1.is_pressed and Server.player_node.character_stats.character_name == "technomancer":
		$aim_los.position = Vector2(960,540)
		show_lobbed_projectile_line(delta,"1",132)
	elif attack_joystick1.is_pressed and Server.player_node.character_stats.character_name == "valkyrie":
		attack_joystick1.check_if_shoot_projectile()
#	elif attack_joystick2.is_pressed:
#		$aim_los.position = Vector2(960,540) + (Server.ally_node1.position - Server.player_node.position)
#		show_straight_projectile_line()
#	elif attack_joystick3.is_pressed:
#		$aim_los.position = Vector2(960,540) + (Server.ally_node2.position - Server.player_node.position)
#		show_lobbed_projectile_line(delta,"3",132)

	if not attack_joystick1.posVector == Vector2.ZERO:
		var angle = rad_to_deg(Vector2(1,0).angle_to(attack_joystick1.posVector))
		$aim_los.rotation_degrees = angle
#	elif not attack_joystick2.posVector == Vector2.ZERO:
#		var angle = rad_to_deg(Vector2(1,0).angle_to(attack_joystick2.posVector))
#		$aim_los.rotation_degrees = angle
#	elif not attack_joystick3.posVector == Vector2.ZERO:
#		var angle = rad_to_deg(Vector2(1,0).angle_to(attack_joystick3.posVector))
#		$aim_los.rotation_degrees = angle


func show_straight_projectile_line():
	$aim_los/start_pt/straight_projectile_line.show()


func show_lobbed_projectile_line(delta,joystick,radius_of_attack):
	var aim_line = $lobbed_projectile_line
	aim_line.show()
	aim_line.radius = radius_of_attack
	
	var spawn_pt = ($aim_los/start_pt.global_position - $aim_los.global_position) + $aim_los.position
	aim_line.strength_coefficient = get_node("action_buttons/attack_joystick"+str(joystick)).strength_coefficient
	aim_line.start_pt = spawn_pt

	var aim_vector = ($aim_los/start_pt.global_position - $aim_los.global_position) * 1.5
	aim_vector.x *= 1.5
	
	aim_line.end_pt = lerp(aim_line.end_pt,(((aim_vector)*(get_node("action_buttons/attack_joystick"+str(joystick)).strength_coefficient*8) + spawn_pt)),delta*15)


func remove_lobbed_projectile_line():
	$aim_los/start_pt/straight_projectile_line.hide()
	$lobbed_projectile_line.hide()
