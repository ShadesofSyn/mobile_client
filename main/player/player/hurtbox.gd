extends Area2D

@onready var progress_bar: TextureProgressBar = $TextureProgressBar

var current_health: int
var maximum_health: int


func _ready():
	await get_tree().process_frame
	maximum_health = Constants.character_data[get_parent().stats.character_name]["stats"]["health"]
	current_health = maximum_health
	progress_bar.max_value = maximum_health
	progress_bar.value = 50
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	pass # Replace with function body.
