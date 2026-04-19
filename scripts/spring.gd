extends Area2D

@export var jump_strength: float = 200

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.do_jump(Vector2.UP * jump_strength)
		body.reset_air_jumps()
