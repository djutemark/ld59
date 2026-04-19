extends CanvasLayer

@export var gui_key: PackedScene
@export var allowed_time_seconds: float = 60 * 10

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

var _elapsed_seconds := 0.0

static func to_bit_string(value: int) -> String:
	return String.num_int64(value, 2)


func _process(delta: float) -> void:
	_elapsed_seconds += delta
	var seconds_left := allowed_time_seconds - _elapsed_seconds
	
	%Timer.text = seconds_to_display(seconds_left)


static func seconds_to_display(total_seconds: float) -> String:
	var full_seconds := (floor(total_seconds) as int) % 60
	var minutes: int = floor(total_seconds) / 60
	var hundredths := (floor(total_seconds * 100.0) as int) % 100
	return "%d:%02d.%02d" % [minutes, full_seconds, hundredths]


func _update_uses_text() -> void:
	%NumUses.text = "Signals: %d / %d" % [current_signal_uses, max_signal_uses]

func _add_keys_gui(keys: int) -> void:
	print("keys_to_activate = ", to_bit_string(keys))
	for i in range(3):
		var bit = 1 << i
		
		if bit & keys != 0:
			var color = Key.key_type_to_color(bit)
			var k = gui_key.instantiate()
			(k as CanvasItem).modulate = color
			%KeysContainer.add_child(k)
