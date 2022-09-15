extends Node2D

onready var tileMap := $Tilemaps/TileMap
onready var hiddenTilemap := $Tilemaps/Hidden_Tilemap
onready var secretsTilemap := $Tilemaps/Secrets_Tilemap
onready var player := $Player
onready var camera2D := $Camera2D

const coin = preload("res://Player/Coin.tscn")
const corpse = preload("res://Player/Corpse.tscn")
const playerScene = preload("res://Player/Player.tscn")

var rng = RandomNumberGenerator.new()
var player_spawn_location = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connectCamera(camera2D)
	Events.connect("win_game", self, "on_win_game")
	Events.connect("restart_game", self, "on_restart_game")
	Events.connect("ring_on", self, "on_ring_on")
	Events.connect("ring_off", self, "on_ring_off")
	Events.connect("player_died", self, "on_player_died")
	Events.connect("hit_checkpoint", self, "on_hit_checkpoint")
	hiddenTilemap.visible = false
	hiddenTilemap.disappear()
	player_spawn_location = player.global_position
	SoundPlayer.play_music(SoundPlayer.FIRST_STORY)

func on_win_game():
	get_tree().change_scene("res://World/WinScreen.tscn")
	
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
	new_coin.angular_velocity = sign(x_velocity)*7
	new_coin.position = player.global_position
	new_coin.position.y -= 12
	add_child(new_coin)
	
	var new_corpse = corpse.instance()
	new_corpse.linear_velocity.x = x_velocity
	new_corpse.angular_velocity = sign(x_velocity)*7
	new_corpse.position = player.global_position
	new_corpse.position.y -= 5
	add_child(new_corpse)
	
	yield(get_tree().create_timer(1.5),"timeout")
	player = playerScene.instance()
	player.position = player_spawn_location
	player.z_index = 10
	add_child(player)
	player.connectCamera(camera2D)
	
	yield(get_tree().create_timer(1.5),"timeout")
	new_coin.queue_free()
	new_corpse.queue_free()
	
func on_hit_checkpoint(position):
	player_spawn_location = position
