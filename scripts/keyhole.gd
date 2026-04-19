class_name Keyhole
extends Area2D

@export var required_key: Key.KeyType = Key.KeyType.CUBE

func _ready() -> void:
	%Locked.visible = true
	%Unlocked.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var res = body.collected_keys & required_key
		var should_unlock = res == required_key
		
		if should_unlock:
			%Locked.visible = false
			%Unlocked.visible = true
