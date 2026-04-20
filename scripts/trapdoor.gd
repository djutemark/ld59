extends KeyTrigger


func _ready() -> void:
	super()
	_update_visibility()
	required_key_change.connect(_update_visibility)
	unlock.connect(_on_unlock)


func _update_visibility() -> void:
	var color := Key.key_type_to_color(required_key)
	@warning_ignore("unsafe_property_access")
	%TrapdoorSprite1.modulate = color
	@warning_ignore("unsafe_property_access")
	%TrapdoorSprite2.modulate = color
	@warning_ignore("unsafe_property_access")
	%TrapdoorSprite3.modulate = color


func _on_unlock() -> void:
	queue_free()
