extends Control


const MAX_TEAM_SCORE: float = 1000
const ICON_TRAVEL_DISTANCE: float = 264



func _ready():
	set_team_favor()
	Server.connect("update_favor",Callable(self,"set_team_favor"))


func set_team_favor():
	$left_team_rect/progress_bar.value = Server.left_team_favor




