class_name Checkpoint
extends Area2D

@export var dehighlight_alpha: float = 0.25
@export var highlight_alpha: float = 0.8

func _ready() -> void:
	dehighlight()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_checkpoint(self)


func highlight() -> void:
	modulate.a = highlight_alpha


func dehighlight() -> void:
	modulate.a = dehighlight_alpha
