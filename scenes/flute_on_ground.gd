extends Sprite2D

@onready var player: Player = $"../player"

signal player_picking_up

func _ready() -> void:
	player_picking_up.connect(Callable.create(player, "pick_up_flute"))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_picking_up.emit()
		queue_free()
