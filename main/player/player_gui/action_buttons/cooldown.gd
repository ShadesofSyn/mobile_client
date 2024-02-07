extends Control

var length: float

func start(_length):
	length = _length
	$Timer.start(_length)
	$TextureProgressBar.value = $Timer.time_left*length

func _physics_process(delta):
	if not $Timer.time_left == 0.0:
		$TextureProgressBar.value = $Timer.time_left*length
		$Label.text = str(snapped($Timer.time_left,0.1))
		return
