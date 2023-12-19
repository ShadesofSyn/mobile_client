extends Label

var length 
var title

func _ready():
	text = title + " - " + str(snapped($Timer.time_left,0.1))
	$Timer.start(length)

func _physics_process(delta):
	text = title + " - " + str(snapped($Timer.time_left,0.1))

func _on_timer_timeout():
	call_deferred("queue_free")
