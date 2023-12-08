extends Control

@onready var left_team_icon = $left_team_rect/icon
@onready var left_team_score_label = $left_team_rect/icon/score_label
@onready var left_line = $left_team_rect/line

@onready var right_team_icon = $right_team_rect/icon
@onready var right_team_score_label = $right_team_rect/icon/score_label
@onready var right_line = $right_team_rect/line

const MAX_TEAM_SCORE: float = 100
const ICON_TRAVEL_DISTANCE: float = 264



func _ready():
	set_left_team_position()
	set_right_team_position()


func set_left_team_position():
	var progress_amt = float(Server.left_team_favor) / MAX_TEAM_SCORE
	left_team_icon.position.x = progress_amt * ICON_TRAVEL_DISTANCE
	left_team_score_label.text = str(Server.left_team_favor)
	left_line.points = [Vector2(20,40),Vector2((progress_amt*260)+20,40)]


func set_right_team_position():
	var progress_amt = float(Server.right_team_favor) / MAX_TEAM_SCORE
	right_team_icon.position.x = ICON_TRAVEL_DISTANCE - (progress_amt * ICON_TRAVEL_DISTANCE)
	right_team_score_label.text = str(Server.right_team_favor)
	right_line.points = [Vector2(280,40),Vector2(260-(progress_amt*260),40)]



