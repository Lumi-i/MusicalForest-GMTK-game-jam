extends CharacterBody2D

var at_player = false
var thrown = false

var selected = false

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var player: Player = $"../player"
@onready var detect: Area2D = $Area2D
@onready var hurtbox: Area2D = $hurtbox


func _physics_process(delta: float) -> void:
	if thrown:
		move_and_slide()
		if not get_viewport_rect().has_point(global_position):
			queue_free()
	else:
		if !at_player:
			nav.target_position = player.global_position
			var direction = (nav.get_next_path_position() - global_position).normalized()
			velocity = direction * 10
			move_and_slide()
	
	
	var bodies_near = detect.get_overlapping_bodies()
	at_player = false
	
	for body in bodies_near:
		if body is Player:
			at_player = true
			break
	
	
	
	
	var bodies_touching = hurtbox.get_overlapping_bodies()
	
	for body in bodies_touching:
		if body.is_in_group("hitable"):
			self.queue_free()
	

func throw():
	if !thrown:
		var mouse_pos = get_global_mouse_position() + Vector2(0, 20)
		var direction = (mouse_pos - global_position).normalized()
		
		velocity = direction * 80
		
		thrown = true
