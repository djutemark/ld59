class_name Invisibility
extends Node2D

@export var time_visible: float = 3

func _enter_tree() -> void:
	Signaler.make_visible.connect(make_visible)
	visible = false

func make_visible() -> void:
	visible = true
	await get_tree().create_timer(time_visible).timeout
	visible = false
