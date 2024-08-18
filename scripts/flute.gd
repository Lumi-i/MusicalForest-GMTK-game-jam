extends Node2D

signal player_picked_up
signal melody_detected(melody_name: String)
signal pick_rock_up

@onready var player: Player = $"../Player"
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

var current_input = []
var max_melody_length = 16
var delay_duration = 0.3
var is_delayed = false

var melodies = {
	"melody_1": ["do", "re", "mi"],
	"melody_2": ["fa", "sol", "la"],
	"melody_3": ["do", "fa", "la", "si"],
	"seven_nation_army": ["la", "la", "do2", "la", "sol", "fa", "mi"],
	"pick_up_rock": ["fa", "mi", "fa", "la", "do2", "la", "sol", "la", "si", "la"],
	"drop_rock": ["fa", "mi", "fa", "la", "do2", "si", "la"],
	"tame": ["sol", "re", "fa", "re", "sol", "re", "sol", "si"]
}


func _ready() -> void:
	connect("melody_detected", Callable(player, "on_melody_detected"))

func _physics_process(delta: float) -> void:
	
	print(current_input)
	
	if Input.is_action_just_pressed("do"):
		play_note_with_delay("do", "res://assets/music/flute/do.mp3")
	if Input.is_action_just_pressed("re"):
		play_note_with_delay("re", "res://assets/music/flute/re.mp3")
	if Input.is_action_just_pressed("mi"):
		play_note_with_delay("mi", "res://assets/music/flute/mi.mp3")
	if Input.is_action_just_pressed("fa"):
		play_note_with_delay("fa", "res://assets/music/flute/fa.mp3")
	if Input.is_action_just_pressed("sol"):
		play_note_with_delay("sol", "res://assets/music/flute/sol.mp3")
	if Input.is_action_just_pressed("la"):
		play_note_with_delay("la", "res://assets/music/flute/la.mp3")
	if Input.is_action_just_pressed("si"):
		play_note_with_delay("si", "res://assets/music/flute/si.mp3")
	if Input.is_action_just_pressed("do2"):
		play_note_with_delay("do2", "res://assets/music/flute/do2.mp3")

func play_note_with_delay(note: String, audio_path: String) -> void:
	if not is_delayed:
		current_input.append(note)

		if current_input.size() > max_melody_length:
			current_input.pop_front()


		var new_sound = AudioStreamPlayer2D.new()
		add_child(new_sound)
		new_sound.stream = ResourceLoader.load(audio_path) as AudioStream
		new_sound.play()
		
		var detected_melody = check_melodies()
		if detected_melody != "":
			handle_detected_melody(detected_melody)

		is_delayed = true
		await get_tree().create_timer(delay_duration).timeout
		is_delayed = false

func _on_AudioStreamPlayer2D_finished():
	queue_free()

func check_melodies() -> String:
	for melody_name in melodies.keys():
		var melody = melodies[melody_name]
		var melody_length = melody.size()

		if current_input.size() >= melody_length:
			var start_index = current_input.size() - melody_length
			var recent_input = current_input.slice(start_index, current_input.size())

			if recent_input == melody:
				current_input.clear()
				return melody_name
	return ""


func handle_detected_melody(melody_name: String) -> void:
	emit_signal("melody_detected", melody_name)
	print(melody_name + " i have handled")
