class_name Spikes
extends Invisibility

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		print("take damage!")
		body.take_damage()
