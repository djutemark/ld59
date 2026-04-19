class_name Chest
extends KeyTrigger

var is_locked: bool = true

func _ready() -> void:
	_update_visibility()
	required_key_change.connect(_update_visibility)

	self.unlock.connect(func() -> void:
		is_locked = false
		_update_visibility()
	)


func _update_visibility() -> void:
	var color: Color = Key.key_type_to_color(required_key)
	
	%Locked.visible = is_locked
	%Locked.modulate = color
	%Unlocked.visible = !is_locked
	%Unlocked.modulate = color
