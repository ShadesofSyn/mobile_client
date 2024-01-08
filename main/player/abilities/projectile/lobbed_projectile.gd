extends Node2D



var destroyed: bool = false
var path
var player_pos


var strength
var zoom = 1.0 #4.5

var spawn_pos: Vector2

var end_pt: Vector2

var type: String

func _ready():
	$ArchedPath.curve.clear_points()
	spawn_pos = return_adjusted_path_position(path[0])
	position = spawn_pos
	set_path()
	move_projectile_and_shadow()
	
	
func set_path():
	end_pt = return_adjusted_path_position(path[path.size()-1])-spawn_pos
	for loc in path:
		$ArchedPath.curve.add_point(Vector2i(return_adjusted_path_position(loc)-spawn_pos))
#	$ShadownPath.curve.add_point(return_adjusted_path_position(path[0])-spawn_pos)
#	$ShadownPath.curve.add_point(end_pt)
#	await get_tree().process_frame
#	$Line2D.points = $ArchedPath.curve.get_baked_points()
	
	
func move_projectile_and_shadow():
	var length = strength*1.5
	await get_tree().process_frame
	var tween = get_tree().create_tween()
	tween.parallel().tween_property($ArchedPath/PathFollow2D,"progress_ratio",1.0,length).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT_IN)
#	tween.parallel().tween_property($ShadownPath/PathFollow2D,"progress_ratio",1.0,length)#.set_ease(Tween.EASE_IN)
	await get_tree().create_timer(length).timeout
	add_projectile_to_world()
	await get_tree().process_frame
	call_deferred("queue_free")



func add_projectile_to_world():
	var spawn_projectile_pos = end_pt+spawn_pos
	match type:
		"tech":
			InstancedScenes.init_technomancer_ultra(spawn_projectile_pos,"blue")
		"mari":
			InstancedScenes.init_mariselle_ultra(spawn_projectile_pos,"blue")
#			InstancedScenes.add_technomancer_explosion("basic",spawn_projectile_pos)
#		"tech-special":
#			InstancedScenes.add_technomancer_explosion("special",spawn_projectile_pos)
#		"tech-ultimate":
#			InstancedScenes.add_matrix_overload(spawn_projectile_pos)
#		"nano-ultimate":
#			InstancedScenes.add_nanomedic_beacon(spawn_projectile_pos)
	


func return_adjusted_path_position(path_pos) -> Vector2:
	return ((path_pos-Vector2(1920,1080)/2)/zoom) + player_pos
	


func destroy():
	if not destroyed:
		destroyed = true
		call_deferred("queue_free")
