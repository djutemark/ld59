extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(other: Node2D):
	var p := other as Player
	if p:
		p.max_num_air_jumps += 1
	queue_free()
