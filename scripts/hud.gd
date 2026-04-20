class_name HUD
extends CanvasLayer

@export var gui_key: PackedScene

var current_signal_uses: int:
	get:
		return current_signal_uses
	set(value):
		current_signal_uses = value
		_update_uses_text()

var max_signal_uses: int:
	get:
		return max_signal_uses
	set(value):
		max_signal_uses = value
		_update_uses_text()

var collected_keys: int = 0:
	get:
		return collected_keys
	set(value):
		var keys_to_activate := (collected_keys | value) ^ collected_keys
		_add_keys_gui(keys_to_activate)
		collected_keys = value

static func to_bit_string(value: int) -> String:
	return String.num_int64(value, 2)


func _process(_delta: float) -> void:
	var time_left: float = Stats.allowed_time_seconds - Stats.total_elapsed_time_seconds
	@warning_ignore("unsafe_property_access")
	%Timer.text = seconds_to_display(time_left)
	
	if time_left < 0:
		# This is so unstructed lol!
		Stats.is_tracking_elapsed_time = false
		get_tree().change_scene_to_file("res://menus/game_over.tscn")


static func seconds_to_display(total_seconds: float) -> String:
	var floored_seconds: int = floor(total_seconds)
	
	@warning_ignore("integer_division")
	var minutes := floored_seconds / 60
	var full_seconds := (floored_seconds as int) % 60
	var hundredths := floori(total_seconds * 100.0) % 100
	return "%d:%02d.%02d" % [minutes, full_seconds, hundredths]


func _update_uses_text() -> void:
	@warning_ignore("unsafe_property_access")
	%NumUses.text = "Signals: %d" % [max_signal_uses - current_signal_uses]

func _add_keys_gui(keys: int) -> void:
	for i in range(3):
		var bit := 1 << i
		
		if bit & keys != 0:
			var color := Key.key_type_to_color(bit)
			@warning_ignore("unsafe_cast")
			var k = gui_key.instantiate() as CanvasItem
			k.modulate = color
			@warning_ignore("unsafe_call_argument")
			%KeysContainer.add_child(k)
