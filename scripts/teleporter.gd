class_name Teleporter
extends Area2D

@export var teleport_target: Node2D


func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	

func _on_body_entered(other: Node2D) -> void:
	if other is Player:
		other.unset_checkpoint()
		other.respawn_position = teleport_target
		other.respawn()
