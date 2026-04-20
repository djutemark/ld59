extends Area2D

@export var num_extra_signals: int = 10

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(other: Node2D):
	var player = other as Player
	if player:
		player.add_max_jumps(num_extra_signals)
		Audio.play(Audio.Sound.Pickup)
	queue_free()
