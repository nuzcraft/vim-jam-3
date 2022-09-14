extends Node

#const HURT = preload("res://sounds/hurt.wav")
const JUMP = preload("res://Sounds/jump.wav")
const LOSE = preload("res://Sounds/lose.wav")
const CHECKPOINT = preload("res://Sounds/checkpoint.wav")
const ON = preload("res://Sounds/on.ogg")
const OFF = preload("res://Sounds/off.ogg")

onready var audioPlayers := $AudioPlayers

func play_sound(sound):	
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.volume_db = 0
			if sound == ON or sound == OFF:
				audioStreamPlayer.volume_db = -20
			audioStreamPlayer.play()
			break

