extends CharacterBody2D

@export var speed = 35

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var player: Player = $"../player"
@onready var detection: Area2D = $detection
@onready var spawn_point: Marker2D = $"../Marker2D"

var sees_player
var timer_ongoing

var state = "idle"

func _ready() -> void:
	state = "idle"

func _physics_process(delta: float) -> void:
	print("state: ", state)
	print("timer is ongoing?: ", timer_ongoing)
	
	var bodies_in_detection = detection.get_overlapping_bodies()
	for body in bodies_in_detection:
		if body is Player:
			sees_player = true
			state = "chase"
		else:
			sees_player = false
			state = "idle"
	
	match state:
		"idle":
			if global_position != spawn_point.global_position - Vector2(10, 10):
				nav.target_position = spawn_point.global_position
				var direction = (nav.get_next_path_position() - global_position).normalized()
				velocity = direction * speed
				move_and_slide()
			else:
				velocity = Vector2.ZERO
		"chase":
			nav.target_position = player.global_position
			var direction = (nav.get_next_path_position() - global_position).normalized()
			velocity = direction * speed
			
			move_and_slide()
