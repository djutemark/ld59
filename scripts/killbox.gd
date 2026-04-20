class_name Killbox
extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(other: Node2D) -> void:
	var p := other as Player
	if p:
		p.take_damage()
