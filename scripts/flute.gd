extends Node2D
class_name flute

signal player_picked_up

@onready var player: Player = $"../player"

@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

var playing = false



func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("do"):
		if !playing:
			sound.stream = load("res://assets/music/flute/do.mp3")
			sound.play()
	if Input.is_action_just_pressed("re"):
		if !playing:
			sound.stream = load("res://assets/music/flute/re.mp3")
			sound.play()
	if Input.is_action_just_pressed("mi"):
		if !playing:
			sound.stream = load("res://assets/music/flute/mi.mp3")
			sound.play()
	if Input.is_action_just_pressed("fa"):
		if !playing:
			sound.stream = load("res://assets/music/flute/fa.mp3")
			sound.play()
	if Input.is_action_just_pressed("sol"):
		if !playing:
			sound.stream = load("res://assets/music/flute/sol.mp3")
			sound.play()
	if Input.is_action_just_pressed("la"):
		if !playing:
			sound.stream = load("res://assets/music/flute/la.mp3")
			sound.play()
	if Input.is_action_just_pressed("si"):
		if !playing:
			sound.stream = load("res://assets/music/flute/si.mp3")
			sound.play()
	if Input.is_action_just_pressed("do2"):
		if !playing:
			sound.stream = load("res://assets/music/flute/do2.mp3")
			sound.play()
