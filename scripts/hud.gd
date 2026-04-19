extends CanvasLayer

@export var gui_key: PackedScene

var current_signal_uses: int:
	get:
		return current_signal_uses
	set(value):
		current_signal_uses = value
		_update_uses_text()

var max_signal_uses: int:
	set(value):
		max_signal_uses = value
		_update_uses_text()

var collected_keys: int = 0:
	get:
		return collected_keys
	set(value):
		var keys_to_activate = (collected_keys | value) ^ collected_keys
		_add_keys_gui(keys_to_activate)
		collected_keys = value


static func to_bit_string(value: int) -> String:
	return String.num_int64(value, 2)


func _update_uses_text() -> void:
	%NumUses.text = "Signaler uses: %d / %d" % [current_signal_uses, max_signal_uses]

func _add_keys_gui(keys: int) -> void:
	print("keys_to_activate = ", to_bit_string(keys))
	for i in range(3):
		var bit = 1 << i
		
		if bit & keys != 0:
			var color = Key.key_type_to_color(bit)
			var k = gui_key.instantiate()
			(k as CanvasItem).modulate = color
			%KeysContainer.add_child(k)
		
