extends Area2D

var items_in_range = {}


func _on_body_entered(body):
	items_in_range[body] = body


func _on_body_exited(body):
	if items_in_range.has(body):
		items_in_range.erase(body)


func _process(_delta) -> void:
	if items_in_range.size() > 0:
		var pickup_item = items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		items_in_range.erase(pickup_item)
