extends Area2D

@export var num_extra_signals: int = 3

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(other: Node2D):
	if other is Player:
		other.signal_settings.max_usage += num_extra_signals
		other.update_signaler_settings()
	queue_free()
