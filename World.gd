extends Node2D

onready var tileMap := $TileMap
onready var hiddenTilemap := $Hidden_Tilemap
onready var secretsTilemap := $Secrets_Tilemap
onready var player := $Player

const greyScale = preload("res://TileMap/Greyscale.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("win_game", self, "on_win_game")
	Events.connect("restart_game", self, "on_restart_game")
	Events.connect("ring_on", self, "on_ring_on")
	Events.connect("ring_off", self, "on_ring_off")
	hiddenTilemap.visible = false
	hiddenTilemap.disappear()

func on_win_game():
	get_tree().change_scene("res://WinScreen.tscn")
	
func on_restart_game():
	get_tree().reload_current_scene()
	
func on_ring_on():
	tileMap.goGreyscale()
	hiddenTilemap.visible = true
	hiddenTilemap.reappear()
	secretsTilemap.disappear()
	player.set_collision_mask_bit(4, true)
	player.set_collision_mask_bit(5, false)
	
func on_ring_off():
	tileMap.returnFromGreyscale()
	hiddenTilemap.disappear()
	secretsTilemap.reappear()
	player.set_collision_mask_bit(4, false)
	player.set_collision_mask_bit(5, true)
