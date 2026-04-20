class_name Checkpoint
extends Area2D

@export var active_color: Color = Color.WEB_GREEN

func _ready() -> void:
	dehighlight()


func _on_body_entered(body: Node2D) -> void:
	var p := body as Player
	if p:
		p.set_checkpoint(self)


func _set_flag_color(color: Color) -> void:
	@warning_ignore("unsafe_property_access")
	%Flag.modulate = color
	@warning_ignore("unsafe_property_access")
	%Flag2.modulate = color


func highlight() -> void:
	_set_flag_color(active_color)
	Audio.play(Audio.Sound.CheckpointActivated)


func dehighlight() -> void:
	_set_flag_color(Color.WHITE)
