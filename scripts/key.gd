class_name Key
extends Area2D

enum KeyType {
	CUBE = 1 << 0,
	CIRCLE = 1 << 1,
	TRIANGLE = 1 << 2,
	ALL = (1 << 3) - 1
}

@export var key_type: KeyType = KeyType.CUBE

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_key(key_type)
		queue_free()
	
