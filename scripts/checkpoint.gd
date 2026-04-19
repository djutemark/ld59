class_name Checkpoint
extends Area2D

@export var active_color: Color = Color.WEB_GREEN

func _ready() -> void:
	dehighlight()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_checkpoint(self)


func _set_flag_color(color: Color) -> void:
	%Flag.modulate = color
	%Flag2.modulate = color


func highlight() -> void:
	_set_flag_color(active_color)


func dehighlight() -> void:
	_set_flag_color(Color.WHITE)
