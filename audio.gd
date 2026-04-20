extends Node

@export var background: AudioStream
@export var jump: AudioStream # doorOpen_002
@export var signal_pulse: SoundCollection
@export var respawn: AudioStream
@export var out_of_bounds: AudioStream
@export var pickup: AudioStream
@export var checkpoint_activated: AudioStream
@export var game_start: AudioStream

enum Sound {
	Jump,
	SignalPulse,
	Respawn,
	OutOfBounds,
	Walk,
	Pickup,
	CheckpointActivated,
	GameStart,
}
# Returns either AudioStream OR SoundCollection
func _sound_to_stream(sound: Sound) -> Variant:
	match sound:
		Sound.Jump: return jump
		Sound.SignalPulse: return signal_pulse
		Sound.Respawn: return respawn
		Sound.OutOfBounds: return out_of_bounds
		Sound.Pickup: return pickup
		Sound.CheckpointActivated: return checkpoint_activated
		Sound.GameStart: return game_start
		_: return null


func _sound_pitch(sound: Sound) -> float:
	match sound:
		Sound.Jump: return randf_range(0.5, 0.6)
		Sound.Walk: return randf_range(0.75, 1.5)
		_: return 1.0

func _sound_volume(sound: Sound) -> float:
	match sound:
		Sound.Jump: return -6.0
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
		var volume := _sound_volume(sound)

		if stream is AudioStream:
			@warning_ignore("unsafe_cast")
			_create_and_play_stream(stream as AudioStream, pitch, volume)
		elif stream is SoundCollection:
			@warning_ignore("unsafe_cast")
			for s in (stream as SoundCollection).sounds:
				await _create_and_play_stream(s, pitch, volume)


func _create_and_play_stream(stream: AudioStream, pitch: float = 1.0, volume_db_offset: float = 1.0) -> void:
	var p := AudioStreamPlayer.new()
	p.stream = stream
	p.pitch_scale = pitch
	p.volume_db = volume_db_offset
	p.finished.connect(p.queue_free)
	add_child(p)
	p.play()
	await p.finished
