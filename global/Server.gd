extends Node

signal update_favor

var player_node = null
var ally_node1 = null
var ally_node2 = null
var world = null
var team_selected: int 
var special_ability_selected: String 


var left_team_favor: int = 0
var right_team_favor: int = 0


func pick_up_item():
	left_team_favor += 10
	emit_signal("update_favor")
	
