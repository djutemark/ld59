extends CanvasLayer

var _current_signal_uses: int = 0
var _max_signal_uses: int = 0

var current_signal_uses: int:
	set(value):
		_current_signal_uses = value
		_update_uses_text()

var max_signal_uses: int:
	set(value):
		_max_signal_uses = value
		_update_uses_text()

func _update_uses_text() -> void:
	%NumUses.text = "Signaler uses: %d / %d" % [_current_signal_uses, _max_signal_uses]
