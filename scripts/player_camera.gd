extends Camera2D

@export var player: Player

@export_range(1, 100, 1)
var camera_speed: float = 25

func _process(_delta: float) -> void:
	position = lerp(position, player.position, camera_speed / 100.0)
