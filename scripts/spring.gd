extends Area2D

@export var jump_strength: float = 200
#@export var reset_air_jumps: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.do_jump(Vector2.UP * jump_strength)
		#if reset_air_jumps:
			#body.reset_air_jumps()
