extends Node


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

func init_steelthorn_ultra(_pos,team_color) -> void:
	var ult = preload("res://main/player/abilities/steelthorn/ultra/steelthorn_ultra.tscn").instantiate()
#	ult.team_color = team_color
	ult.position = _pos
	Server.world.projectiles.call_deferred("add_child",ult)
	
