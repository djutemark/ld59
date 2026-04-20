extends Node

@export var background: AudioStream
@export var jump: AudioStream # doorOpen_002
@export var signal_pulse: SoundCollection
@export var respawn: AudioStream
@export var out_of_bounds: AudioStream
@export var pickup: AudioStream

enum Sound {
	Jump,
	SignalPulse,
	Respawn,
	OutOfBounds,
	Walk,
	Pickup,
}
# Returns either AudioStream OR SoundCollection
func _sound_to_stream(sound: Sound) -> Variant:
	match sound:
		Sound.Jump: return jump
		Sound.SignalPulse: return signal_pulse
		Sound.Respawn: return respawn
		Sound.OutOfBounds: return out_of_bounds
		Sound.Pickup: return pickup
		_: return null


func _sound_pitch(sound: Sound) -> float:
	const PITCH_LOW: float = 0.75
	const PITCH_HIGH: float = 1.5
	match sound:
		Sound.Jump: return randf_range(PITCH_LOW, PITCH_HIGH)
		Sound.Walk: return randf_range(PITCH_LOW, PITCH_HIGH)
		_: return 1.0


func _ready() -> void:
	if background != null:
		var p := AudioStreamPlayer.new()
		p.stream = background
		add_child(p)
		p.play()


func play(sound: Sound) -> void:
	var stream = _sound_to_stream(sound)
	
	if stream != null:
		var pitch := _sound_pitch(sound)

		if stream is AudioStream:
			@warning_ignore("unsafe_cast")
			_create_and_play_stream(stream as AudioStream, pitch)
		elif stream is SoundCollection:
			@warning_ignore("unsafe_cast")
			for s in (stream as SoundCollection).sounds:
				await _create_and_play_stream(s, pitch)


func _create_and_play_stream(stream: AudioStream, pitch: float = 1.0) -> void:
	var p := AudioStreamPlayer.new()
	p.stream = stream
	p.pitch_scale = pitch
	p.finished.connect(p.queue_free)
	add_child(p)
	p.play()
	await p.finished
