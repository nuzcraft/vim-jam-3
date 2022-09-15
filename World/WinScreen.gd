extends MarginContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("restart_game"):
		get_tree().change_scene("res://World/World.tscn")
