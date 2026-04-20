class_name Killbox
extends Area2D

@export var damage_type: Player.DamageType = Player.DamageType.Spikes

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(other: Node2D) -> void:
	var p := other as Player
	if p:
		p.take_damage(damage_type)
