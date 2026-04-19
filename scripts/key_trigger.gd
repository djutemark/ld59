class_name KeyTrigger
extends Area2D

signal unlock
signal required_key_change(new_key_type: Key.KeyType)

@export var required_key: Key.KeyType = Key.KeyType.RED:
	get:
		return required_key
	set(value):
		required_key = value
		required_key_change.emit(value)


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(other: Node2D) -> void:
	if other is Player:
		var should_unlock: bool = (other.collected_keys & required_key) == required_key
		if should_unlock:
			unlock.emit()
