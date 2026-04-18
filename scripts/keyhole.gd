class_name Keyhole
extends Area2D

@export var required_key: Key.KeyType = Key.KeyType.CUBE

func _ready() -> void:
	print("required key = ", required_key)
	%Locked.visible = true
	%Unlocked.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var res = body.collected_keys & required_key
		var should_unlock = res == required_key
		print("res = ", res, " should unlock ? ", should_unlock)
		
		if should_unlock:
			%Locked.visible = false
			%Unlocked.visible = true
