extends Area2D

@export var jump_strength: float = 200

func _on_body_entered(body: Node2D) -> void:
	var p := body as Player
	if p:
		p.do_jump(Vector2.UP * jump_strength)
		p.reset_air_jumps()
