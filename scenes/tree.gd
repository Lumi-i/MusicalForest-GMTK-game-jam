extends CharacterBody2D

@export var speed = 35

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var player: Player = $"../player"
@onready var detection: Area2D = $detection
@onready var spawn_point: Marker2D = $"../Marker2D"
@onready var sprite: Sprite2D = $Sprite2D

var sees_player
var is_hostile = true

var timer_ongoing

var state = "idle"


func _ready() -> void:
	state = "idle"

func _physics_process(delta: float) -> void:
	
	var bodies_in_detection = detection.get_overlapping_bodies()
	for body in bodies_in_detection:
		if body is Player:
			sees_player = true
			if is_hostile:
				state = "chase"
		else:
			sees_player = false
			state = "idle"
	
	match state:
		"idle":
			if global_position != spawn_point.global_position:
				nav.target_position = spawn_point.global_position
				var direction = (nav.get_next_path_position() - global_position).normalized()
				velocity = direction * speed
				move_and_slide()
			else:
				velocity = Vector2.ZERO
		"chase":
			#wakes up
			sprite.flip_v = true
			await get_tree().create_timer(1).timeout
			sprite.flip_v = false
			state = "chase"
			
			#chases
			nav.target_position = player.global_position
			var direction = (nav.get_next_path_position() - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
	
	match is_hostile:
		true:
			sprite.modulate.b = true
		
		false:
			sprite.modulate.b = false


func _on_player_tame() -> void:
	is_hostile = false
