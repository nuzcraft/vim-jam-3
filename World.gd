extends Node2D

onready var tileMap := $TileMap
onready var hiddenTilemap := $Hidden_Tilemap
onready var secretsTilemap := $Secrets_Tilemap
onready var player := $Player

const greyScale = preload("res://TileMap/Greyscale.tres")
const GRASS = 0
const MUD = 1
const SNOW = 2
const ASH = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("win_game", self, "on_win_game")
	Events.connect("restart_game", self, "on_restart_game")
	Events.connect("ring_on", self, "on_ring_on")
	Events.connect("ring_off", self, "on_ring_off")
	hiddenTilemap.visible = false

func on_win_game():
	get_tree().change_scene("res://WinScreen.tscn")
	
func on_restart_game():
	get_tree().reload_current_scene()
	
func on_ring_on():
	tileMap.tile_set.tile_set_material(GRASS, greyScale)
	tileMap.tile_set.tile_set_material(MUD, greyScale)
	tileMap.tile_set.tile_set_material(SNOW, greyScale)
	tileMap.tile_set.tile_set_material(ASH, greyScale)
	hiddenTilemap.visible = true
	secretsTilemap.visible = false
	player.set_collision_mask_bit(4, true)
	player.set_collision_mask_bit(5, false)
	
func on_ring_off():
	tileMap.tile_set.tile_set_material(GRASS, null)
	tileMap.tile_set.tile_set_material(MUD, null)
	tileMap.tile_set.tile_set_material(SNOW, null)
	tileMap.tile_set.tile_set_material(ASH, null)
	hiddenTilemap.visible = false
	secretsTilemap.visible = true
	player.set_collision_mask_bit(4, false)
	player.set_collision_mask_bit(5, true)
