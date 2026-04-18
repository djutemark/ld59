class_name Spikes
extends StaticBody2D

@export var is_hidden: bool = false
@export var time_visible: float = 3

func _enter_tree() -> void:
	if is_hidden:	
		Signaler.make_visible.connect(make_visible)
		visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		print("take damage!")
		body.take_damage(4)


func make_visible() -> void:
	visible = true
	%InvisibilityTimer.start(time_visible)


func make_invisible() -> void:
	visible = false


func _on_invisibility_timer_timeout() -> void:
	make_invisible()
