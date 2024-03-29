extends Node

func init_hit_effect(amt,pos) -> void:
	var effect = preload("res://main/player/effects/hit/hit_effect.tscn").instantiate()
	effect.amount = amt
	effect.position = pos + Vector2(randf_range(-50,50),randf_range(-50,50))
	Server.world.projectiles.call_deferred("add_child",effect)


### 
func init_lobbed_projectile(type:String,joystick_vector:Vector2) -> void:
	var aim_line = Server.player_node.get_node("Camera2D/player_gui/lobbed_projectile_line")
	var projectile = preload("res://main/player/abilities/projectile/lobbed_projectile.tscn").instantiate()
	projectile.type = type
	projectile.strength = aim_line.strength_coefficient
	projectile.path = aim_line.path 
	projectile.player_pos = Server.player_node.position
	Server.world.projectiles.call_deferred("add_child",projectile)


### Basic attacks
func init_technomancer_basic(team_color,velocity,spawn_pt) -> void:
	var proj = preload("res://main/player/abilities/technomancer/basic/technomancer_basic.tscn").instantiate()
	proj.position = spawn_pt
	proj.velocity = velocity
	proj.team_color = team_color
	Server.world.projectiles.call_deferred("add_child",proj)


func init_mariselle_basic(team_color,velocity,spawn_pt) -> void:
	var proj = preload("res://main/player/abilities/mariselle/mariselle_projectile.tscn").instantiate()
	proj.position = spawn_pt
	proj.velocity = velocity
	proj.team_color = team_color
	Server.world.projectiles.call_deferred("add_child",proj)

func init_steelthorn_basic(team_color,velocity,spawn_pt) -> void:
	var proj = preload("res://main/player/abilities/steelthorn/basic/steelthorn_basic.tscn").instantiate()
	proj.position = spawn_pt
	proj.velocity = velocity
	proj.team_color = team_color
	Server.world.projectiles.call_deferred("add_child",proj)
	
	
func init_magmaul_basic(team_color,spawn_pt) -> void:
	var proj = preload("res://main/player/abilities/magmaul/magmaul_basic.tscn").instantiate()
	proj.position = spawn_pt
	proj.team_color = team_color
	Server.world.projectiles.call_deferred("add_child",proj)
	
func init_valkyrie_basic(team_color,velocity,spawn_pt) -> void:
	var proj = preload("res://main/player/abilities/valkyrie/valkyrie_basic.tscn").instantiate()
	proj.velocity = velocity
	proj.position = spawn_pt
	proj.team_color = team_color
	Server.world.projectiles.call_deferred("add_child",proj)

### Ultra attacks
func init_valkyrie_ultra(team_color) -> void:
	var ult = preload("res://main/player/abilities/valkyrie/valkyrie_ultra.tscn").instantiate()
	Server.player_node.call_deferred("add_child",ult)


func init_mariselle_ultra(_pos,team_color) -> void:
	var ult = preload("res://main/player/abilities/mariselle/mariselle_ultra.tscn").instantiate()
	ult.team_color = team_color
	ult.position = _pos
	Server.world.projectiles.call_deferred("add_child",ult)


func init_magmaul_ultra(_pos,team_color) -> void:
	var ult = preload("res://main/player/abilities/magmaul/magmaul_ultra.tscn").instantiate()
	ult.team_color = team_color
	ult.position = _pos
	Server.world.projectiles.call_deferred("add_child",ult)

func init_technomancer_ultra(_pos,team_color) -> void:
	var ult = preload("res://main/player/abilities/technomancer/ultra/technomancer_ultra.tscn").instantiate()
	ult.team_color = team_color
	ult.position = _pos
	Server.world.projectiles.call_deferred("add_child",ult)

func init_steelthorn_ultra(_pos,team_color,aim_vector) -> void:
	var ult = preload("res://main/player/abilities/steelthorn/ultra/steelthorn_ultra.tscn").instantiate()
	ult.aim_vector = aim_vector
	ult.position = _pos
	Server.world.projectiles.call_deferred("add_child",ult)
	
	
### Effects

func init_dash_effect(_node) -> void:
	var dash = preload("res://main/player/abilities/dash/dash.tscn").instantiate()
	_node.call_deferred("add_child",dash)

func init_aggro_effect(_node) -> void:
	var effect = preload("res://main/player/effects/aggro/aggro_effect.tscn").instantiate()
	_node.call_deferred("add_child",effect)

func init_amplify_effect(_node) -> void:
	var effect = preload("res://main/player/effects/amplify/amplify_effect.tscn").instantiate()
	_node.call_deferred("add_child",effect)
	
func init_dispel_effect(_node) -> void:
	var effect = preload("res://main/player/effects/dispel/dispel_effect.tscn").instantiate()
	_node.call_deferred("add_child",effect)
	
func init_rejuvenate_effect(_node) -> void:
	var effect = preload("res://main/player/effects/rejuvenate/rejuvenate_effect.tscn").instantiate()
	_node.call_deferred("add_child",effect)
	
func init_supress_effect(_node) -> void:
	var effect = preload("res://main/player/effects/supress/supress_effect.tscn").instantiate()
	_node.call_deferred("add_child",effect)

func init_war_cry_effect(_node) -> void:
	var effect = preload("res://main/player/effects/war cry/war_cry_effect.tscn").instantiate()
	_node.call_deferred("add_child",effect)

### Misc
func init_item_drop(_pos,special,type = "") -> void:
	var item_drop = preload("res://main/world/map objects/item_drop/item_drop.tscn").instantiate()
	item_drop.type = type
	item_drop.special = special
	item_drop.position = _pos
	Server.world.projectiles.call_deferred("add_child",item_drop)

