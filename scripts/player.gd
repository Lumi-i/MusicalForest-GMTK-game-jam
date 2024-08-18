extends CharacterBody2D
class_name Player

signal rock_pick_up
signal rock_drop
signal tame

@onready var flute = preload("res://scenes/flute.tscn")
@onready var flute_drop = preload("res://scenes/flute_on_ground.tscn")
@onready var rock: CharacterBody2D = $"../rock_obstacle"


@onready var marker_2d: Marker2D = $Marker2D
@onready var world: Node2D = $".."

var SPEED = 50
var dir = Vector2(0, 0)

var current_item = "nothing"
var cooldown_switch = 1
var can_switch = true

var is_detected = false

@onready var player_sprite: Sprite2D = $Sprite2D

func _ready():
	on_melody_detected("test")


func _physics_process(delta: float) -> void:
	
	
	
	if Input.is_action_pressed("up"):
		dir = Vector2(0, -1)
	elif Input.is_action_pressed("down"):
		dir = Vector2(0, 1)
	elif Input.is_action_pressed("left"):
		dir = Vector2(-1, 0)
	elif Input.is_action_pressed("right"):
		dir = Vector2(1, 0)
	else:
		dir = Vector2(0, 0)
	
	velocity = dir * SPEED
	
	
	if dir.x > 0:
		player_sprite.flip_v = true
	elif dir.x < 0:
		player_sprite.flip_v = false
	
	
	move_and_slide()


func pick_up_flute():
	var flute_instance = flute.instantiate()
	flute_instance.position = marker_2d.position
	add_child(flute_instance)
	flute_instance.connect("melody_detected", Callable(self, "on_melody_detected"))
	current_item = "flute"
	can_switch = false
	await get_tree().create_timer(cooldown_switch).timeout
	can_switch = true

func on_melody_detected(melody_name: String) -> void:
	print(melody_name + " received!")
	
	match melody_name:
		"pick_up_rock":
			rock_pick_up.emit()
		
		"drop_rock":
			rock_drop.emit()
		
		"tame":
			tame.emit()
