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
	get: return current_checkpoint.position if current_checkpoint != null else original_position

func _ready() -> void:
	original_position = position
	update_signaler()
	
	%WarningSprite.visible = false
	warning_activated.connect(func(): 
		%WarningSprite.visible = true
	)
	warning_deactivated.connect(func(): 
		%WarningSprite.visible = false
	)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use_signaler"):
		%Signaler.make_signal()
			

func _physics_process(_delta: float) -> void:
	update_velocity()
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		if event.keycode == KEY_R:
			respawn()


func update_signaler() -> void:
	%Signaler.hud = hud
	%Signaler.settings = signal_settings


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

	var horizontal_move = Input.get_axis("move_left", "move_right")
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

	
func respawn() -> void:
	position = respawn_position
	velocity = Vector2.ZERO
	reset_signals()


func reset_signals() -> void:
	%Signaler.reset_signals()

	
func take_damage() -> void:
	Stats.total_num_deaths += 1
	respawn()


func take_key(key: Key.KeyType) -> void:
	collected_keys |= key


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
