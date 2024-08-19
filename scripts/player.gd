extends CharacterBody2D
class_name Player


#shards
@onready var shard_1 = preload("res://scenes/rock_1.tscn")
@onready var shard_2 = preload("res://scenes/rock_2.tscn")

signal throw_shard1
signal throw_shard2
signal throw_shard3
signal throw_shard4

var shard_count = 0

@onready var player_anim: AnimatedSprite2D = $AnimatedSprite2D


#stages
@onready var stage_1: Node2D = $"../Stage1"
@onready var stage_2: Node2D = $"../Stage2"
@onready var stage_3: Node2D = $"../Stage3"

@export var current_stage: Node2D


#flute
@onready var flute = preload("res://scenes/flute.tscn")
@onready var flute_drop = preload("res://scenes/flute_on_ground.tscn")


#rock
signal rock_pick_up
signal rock_drop
signal remove_rock

@onready var rock: CharacterBody2D = $"../Stage1/rock_obstacle"
@export var current_rock: CharacterBody2D = rock


#etc
signal tame

@onready var marker_2d: Marker2D = $Marker2D
@onready var world: Node2D = $".."

var SPEED = 50
var dir = Vector2(0, 0)

var current_item = "nothing"
var cooldown_switch = 1
var can_switch = true

var is_walking = false
var last_dir = "down"



func _ready() -> void:
	player_anim.play("front_idle")
	current_stage = stage_1


func _physics_process(delta: float) -> void:
	
	print(shard_count)
	
	if Input.is_action_pressed("up"):
		dir = Vector2(0, -1)
		is_walking = true
		last_dir = "up"
	elif Input.is_action_pressed("down"):
		dir = Vector2(0, 1)
		is_walking = true
		last_dir = "down"
	elif Input.is_action_pressed("left"):
		dir = Vector2(-1, 0)
		is_walking = true
		last_dir = "left"
	elif Input.is_action_pressed("right"):
		dir = Vector2(1, 0)
		is_walking = true
		last_dir = "right"
	else:
		dir = Vector2.ZERO
		is_walking = false
	
	
	match last_dir:
		"up":
			if is_walking:
				player_anim.play("back_walk")
			else:
				player_anim.play("back_idle")
		"down":
			if is_walking:
				player_anim.play("front_walk")
			else:
				player_anim.play("front_idle")
		"left":
			if is_walking:
				player_anim.play("left_walk")
			else:
				player_anim.play("left_idle")
		
		"right":
			if is_walking:
				player_anim.play("right_walk")
			else:
				player_anim.play("right_idle")
			



	velocity = dir * SPEED
	
	
	
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
		
		"break":
			if rock.in_air:
				print("yooooooooooooooooooooooooooooooooooooooooooo")
				shard_count = 4
				var shard_1_instance = shard_1.instantiate()
				var shard_2_instance = shard_2.instantiate()
				var shard_3_instance = shard_1.instantiate()
				var shard_4_instance = shard_2.instantiate()
				
				shard_1_instance.global_position = rock.global_position + Vector2(1, -1)
				connect("throw_shard1", Callable(shard_1_instance, "throw"))
				shard_2_instance.global_position = rock.global_position + Vector2(-0.5, 2)
				connect("throw_shard2", Callable(shard_2_instance, "throw"))
				shard_3_instance.global_position = rock.global_position + Vector2(1.5, 4)
				connect("throw_shard3", Callable(shard_3_instance, "throw"))
				shard_4_instance.global_position = rock.global_position + Vector2(3, 2)
				connect("throw_shard4", Callable(shard_4_instance, "throw"))
			
				world.add_child(shard_1_instance)
				world.add_child(shard_2_instance)
				world.add_child(shard_3_instance)
				world.add_child(shard_4_instance)
				await get_tree().create_timer(0.01).timeout
				remove_rock.emit()
		"throw":
			if shard_count > 0:
				
				if shard_count == 4:
					throw_shard1.emit()
				elif shard_count == 3:
					throw_shard2.emit()
				elif shard_count == 2:
					throw_shard3.emit()
				elif shard_count == 1:
					throw_shard4.emit()
				
				shard_count -= 1
