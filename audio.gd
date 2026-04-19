extends Node

@export var background: AudioStream
@export var jump: AudioStream
@export var signal_pulse: AudioStream

enum Sound {
	Jump,
	SignalPulse,
}
func _sound_to_stream(sound: Sound) -> AudioStream:
	match sound:
		Sound.Jump: return jump
		Sound.SignalPulse: return signal_pulse
		_: return null


func _ready() -> void:
	if background != null:
		var p := AudioStreamPlayer.new()
		p.stream = background
		add_child(p)
		p.play()


func play(sound: Sound) -> void:
	var stream := _sound_to_stream(sound)
	
	if stream != null:
		var p := AudioStreamPlayer.new()
		p.stream = stream
		p.finished.connect(p.queue_free)
		add_child(p)
		p.play()
