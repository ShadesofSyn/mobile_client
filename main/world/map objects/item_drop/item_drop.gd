extends CharacterBody2D

var player 
var being_picked_up = false
var being_added_to_inventory = false

const MAX_SPEED = 700
const ACCELERATION = 150

var special: bool = false

func _ready():
	if special:
		$Sprite2D.scale *= 2
	$Sprite2D.texture = load("res://assets/tilesets/map objects/crystals/decor_"+ str(randi_range(2,4)) +".png")
	await get_tree().create_timer(0.5).timeout
	$CollisionShape2D.set_deferred("disabled",false)


#func show_indicator():
#	var tween = get_tree().create_tween()
#	tween.tween_property($indicator,"modulate:a",1.0,0.8)
#
#func remove_indicator():
#	var tween = get_tree().create_tween()
#	tween.tween_property($indicator,"modulate:a",0.0,0.1)


func _physics_process(delta):
	if not being_picked_up:
		velocity = Vector2.ZERO
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
		var distance = global_position.distance_to(player.global_position)
		if distance < 12: 
			if being_added_to_inventory:
				return
			else:
				hide()
				being_added_to_inventory = true
				Server.pick_up_item()
				call_deferred("queue_free")

	velocity.normalized()
	move_and_slide()


func pick_up_item(body):
	player = body
	being_picked_up = true
#	remove_indicator()
