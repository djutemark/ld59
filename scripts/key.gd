class_name Key
extends Area2D

enum KeyType {
	RED = 1 << 0,
	GREEN = 1 << 1,
	BLUE = 1 << 2,
	ALL = (1 << 3) - 1
}


static func key_type_to_color(type: KeyType) -> Color:
	match type:
		KeyType.RED: return Color.RED
		KeyType.GREEN: return Color.GREEN
		KeyType.BLUE: return Color.BLUE
		_: return Color.WHITE


@export var key_type: KeyType = KeyType.RED:
	get:
		return key_type
	set(value):
		key_type = value
		_update_color()
		

func _ready() -> void:
	_update_color()


func _update_color():
	@warning_ignore("unsafe_property_access")
	%KeySprite.modulate = key_type_to_color(key_type)


func _on_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player:
		player.take_key(key_type)
		queue_free()
	
