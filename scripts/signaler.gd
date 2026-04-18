extends Node

signal make_visible

func _ready() -> void:
	make_visible.connect(make_visible_called)


func make_visible_called() -> void:
	print("make visible!")
