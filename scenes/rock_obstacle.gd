extends CharacterBody2D

@onready var player: Player = $"../player"
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $collision
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var detect: Area2D = $detect
@onready var detect_collision: CollisionShape2D = $detect/detect_collision


var state = "grounded"
var at_player = false
var in_air = false

func _ready() -> void:
	state = "grounded"


func _physics_process(delta: float) -> void:
	if in_air:
		$collision.disabled = true
	else:
		$collision.disabled = false
	
	var bodies_near = detect.get_overlapping_bodies()
	at_player = false
	for body in bodies_near:
		if body is Player:
			at_player = true
			break
	
	match state:
		"grounded":
			pass
		"controlled":
			if !at_player:
				nav.target_position = player.global_position
				var distance = (nav.get_next_path_position() - global_position).normalized()
				velocity = distance * 10
				move_and_slide()
	
	
	if Input.is_action_just_pressed("f") and in_air:
		var fall = create_tween()
		print("hey")
		fall.tween_property(sprite, "position:y", 0, 1)
		await fall.finished
		in_air = false
		state = "grounded"


func _rock_picked_up() -> void:
	if !in_air:
		var fly_up = create_tween()
		in_air = true
		fly_up.tween_property(sprite, "position:y", -20, 3)
		await fly_up.finished
		state = "controlled"


func _on_player_rock_drop() -> void:
	if in_air:
		var fall = create_tween()
		print("hey")
		fall.tween_property(sprite, "position:y", 0, 1)
		await fall.finished
		in_air = false
		state = "grounded"
