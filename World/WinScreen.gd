extends MarginContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_pressed():
		get_tree().change_scene("res://Title.tscn")
