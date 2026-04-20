class_name Game
extends Node2D

func _enter_tree() -> void:
	Stats.reset()
	Audio.play(Audio.Sound.GameStart)
