extends Node2D

onready var tileMap := $TileMap
onready var hiddenTilemap := $Hidden_Tilemap
onready var secretsTilemap := $Secrets_Tilemap
onready var player := $Player
onready var camera2D := $Player/Camera2D

const greyScale = preload("res://TileMap/Greyscale.tres")
const coin = preload("res://Coin.tscn")
const corpse = preload("res://Corpse.tscn")

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("win_game", self, "on_win_game")
	Events.connect("restart_game", self, "on_restart_game")
	Events.connect("ring_on", self, "on_ring_on")
	Events.connect("ring_off", self, "on_ring_off")
	Events.connect("player_died", self, "on_player_died")
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
	
func on_player_died():
	var new_coin = coin.instance()
	rng.randomize()
	var x_velocity = rng.randi_range(-45, 45)
	new_coin.linear_velocity.x = x_velocity
	new_coin.linear_velocity.y = -100
	new_coin.position = player.global_position
	new_coin.position.y -= 12
	add_child(new_coin)
	
	var new_corpse = corpse.instance()
	new_corpse.linear_velocity.x = x_velocity
	new_corpse.position = player.global_position
	add_child(new_corpse)
	
	yield(get_tree().create_timer(3),"timeout")
	get_tree().reload_current_scene()
