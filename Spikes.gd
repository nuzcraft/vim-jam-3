extends Area2D


func _on_Spikes_body_entered(body):
	if body is Player:
		if not body.dead:
			body.player_dies()
