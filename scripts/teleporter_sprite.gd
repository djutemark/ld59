extends Node2D


func _ready() -> void:
	var children := find_children("*", "AnimatedSprite2D")
	for child in children:
		var c := child as AnimatedSprite2D
		if c != null:
			c.play("default")
