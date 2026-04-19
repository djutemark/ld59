class_name Keyhole
extends Area2D

@export var required_key: Key.KeyType = Key.KeyType.RED:
	get:
		return required_key
	set(value):
		required_key = value
		_update_visibility()


var is_locked: bool = true:
	get:
		return is_locked
	set(value):
		is_locked = value
		_update_visibility()


func _ready() -> void:
	_update_visibility()


func _update_visibility() -> void:
	var color: Color = Key.key_type_to_color(required_key)
	
	%Locked.visible = is_locked
	%Locked.modulate = color
	%Unlocked.visible = !is_locked
	%Unlocked.modulate = color
	

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var res = body.collected_keys & required_key
		var should_unlock = res == required_key
		
		is_locked = !should_unlock
