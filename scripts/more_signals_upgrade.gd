extends Area2D

@export var num_extra_signals: int = 3

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(other: Node2D):
	var player = other as Player
	if player:
		player.signal_settings.max_usage += num_extra_signals
		player.update_signaler()
		Audio.play(Audio.Sound.Pickup)
	queue_free()
