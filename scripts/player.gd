class_name Player
extends CharacterBody2D

@export var gravity_strength: float = 5
@export var move_speed: float = 100
@export var jump_strength: float = 100
@export var max_num_air_jumps: int = 1
@export var air_jump_strength: float = 100

@export var signal_settings: SignalerSettings:
	get:
		return signal_settings
	set(value):
		signal_settings = value
		update_signaler()

@export var hud: HUD:
	get:
		return hud
	set(value):
		hud = value
		update_signaler()

@export var is_walking: bool = false:
	get:
		return is_walking
	set(value):
		if value != is_walking:
			var wa := %WalkAudioPlayer as AudioStreamPlayer
			if value:
				wa.play()
			else:
				wa.stop()
		
		is_walking = value


enum DamageType {
	OutOfBounds,
	Spikes,
}
enum RespawnReason {
	Death,
	Teleport,
	OutOfBounds,
}

var original_position: Vector2
var current_checkpoint: Checkpoint = null
var num_warnings: int = 0

var num_air_jumps: int = 0
var do_jump_called: bool = false

var collected_keys: int = 0:
	get:
		return collected_keys
	set(value):
		collected_keys = value
		hud.collected_keys = value

signal warning_activated
signal warning_deactivated

var respawn_position:
	get: return current_checkpoint.global_position if current_checkpoint != null else original_position

func _ready() -> void:
	original_position = position
	update_signaler()
	
	@warning_ignore("unsafe_property_access")
	%WarningSprite.visible = false
	warning_activated.connect(func(): 
		@warning_ignore("unsafe_property_access")
		%WarningSprite.visible = true
	)
	warning_deactivated.connect(func(): 
		@warning_ignore("unsafe_property_access")
		%WarningSprite.visible = false
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use_signaler"):
		var signaler := %Signaler as Signaler
		if signaler:
			signaler.make_signal()
			

func _physics_process(_delta: float) -> void:
	update_velocity()
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	var key_event := event as InputEventKey
	if key_event:
		if key_event.keycode == KEY_ESCAPE:
			get_tree().quit()
		if key_event.keycode == KEY_R:
			respawn(RespawnReason.Teleport)


func update_signaler() -> void:
	@warning_ignore("unsafe_property_access")
	%Signaler.hud = hud
	@warning_ignore("unsafe_property_access")
	%Signaler.settings = signal_settings


func add_max_jumps(num_extra_signals: int) -> void:
	signal_settings.max_usage += num_extra_signals
	@warning_ignore("unsafe_property_access", "unsafe_cast")
	%Signaler.num_uses -= maxi((%Signaler.num_uses as int) - num_extra_signals, 0)
	update_signaler()


func do_jump(dir: Vector2) -> void:
	do_jump_called = true
	velocity = dir
	Audio.play(Audio.Sound.Jump)
	Stats.total_num_jumps += 1


func reset_air_jumps() -> void:
	num_air_jumps = 0
	

func update_velocity() -> void:
	var is_jumping: bool = Input.is_action_just_pressed("jump")
	
	if is_on_floor() and do_jump_called == false:
		velocity = Vector2.ZERO
		reset_air_jumps()
		
		if is_jumping:
			do_jump(up_direction * jump_strength)
	else:
		if is_jumping and num_air_jumps < max_num_air_jumps:
			num_air_jumps += 1
			do_jump(up_direction * air_jump_strength)
		velocity += gravity_strength * -up_direction

	var horizontal_move := Input.get_axis("move_left", "move_right")	
	is_walking = abs(horizontal_move) > 0 and is_on_floor()
	velocity.x = horizontal_move * move_speed
	do_jump_called = false
	
	
func set_checkpoint(checkpoint: Checkpoint) -> void:
	if current_checkpoint != null:
		current_checkpoint.dehighlight()
	current_checkpoint = checkpoint
	current_checkpoint.highlight()
	reset_signals()
	

func unset_checkpoint() -> void:
	if current_checkpoint != null:
		current_checkpoint.dehighlight()
	current_checkpoint = null

	
func respawn(respawn_reason: RespawnReason) -> void:
	position = respawn_position
	velocity = Vector2.ZERO
	reset_signals()
	
	match respawn_reason:
		RespawnReason.OutOfBounds:Audio.play(Audio.Sound.OutOfBounds)
		_: Audio.play(Audio.Sound.Respawn)


func reset_signals() -> void:
	var s := %Signaler as Signaler
	if s:
		s.reset_signals()

	
func take_damage(type: DamageType) -> void:
	Stats.total_num_deaths += 1
	respawn(RespawnReason.Death if type == DamageType.Spikes else RespawnReason.OutOfBounds)


func take_key(key: Key.KeyType) -> void:
	collected_keys |= key
	Audio.play(Audio.Sound.Pickup)


func _on_warning_entered(other: Node2D) -> void:
	if Invisibility.try_get_invisibility(other) != null:
		if num_warnings == 0:
			warning_activated.emit()
		num_warnings += 1
	

func _on_warning_exited(other: Node2D) -> void:
	if Invisibility.try_get_invisibility(other) != null:
		num_warnings -= 1
		if num_warnings == 0:
			warning_deactivated.emit()
