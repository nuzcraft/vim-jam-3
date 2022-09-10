extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("win_game", self, "on_win_game")
	Events.connect("restart_game", self, "on_restart_game")

func on_win_game():
	get_tree().change_scene("res://WinScreen.tscn")
	
func on_restart_game():
	get_tree().reload_current_scene()
