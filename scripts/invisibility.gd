class_name Invisibility
extends Node

var parent: Node2D

func _ready() -> void:
	parent = get_parent()
	parent.modulate.a = 0


func make_visible() -> void:
	parent.modulate.a = 1


func make_invisible() -> void:
	create_tween().tween_property(parent, "modulate:a", 0, 0.25)


static func try_get_invisibility(node: Node2D) -> Invisibility:
	var invisibilities = node.find_children("*", "Invisibility", false)
	print("trying to get invisibility from ", node.name, " found ", invisibilities)
	
	if invisibilities.size() > 0:
		var invisible_node = invisibilities[0] as Invisibility
		return invisible_node
	return null
