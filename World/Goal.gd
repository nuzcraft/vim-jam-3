extends Area2D

func _on_Goal_body_entered(body):
	if not body is Player: return
	Events.emit_signal("win_game")
