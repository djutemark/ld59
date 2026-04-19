class_name Player
extends CharacterBody2D

@export var gravity_strength: float = 5
@export var move_speed: float = 100
@export var jump_strength: float = 100
@export var max_num_air_jumps: int = 1

@export var signal_settings: SignalerSettings

var original_position: Vector2
var current_checkpoint: Checkpoint = null
var num_warnings: int = 0

var num_air_jumps: int = 0

var collected_keys: int = 0

signal warning_activated
signal warning_deactivated

var respawn_position:
	get: return current_checkpoint.position if current_checkpoint != null else original_position

func _ready() -> void:
	original_position = position
	%Signaler.settings = signal_settings
	HUD.max_signal_uses = signal_settings.max_usage
	
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
	apply_gravity()
	move()
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		if event.keycode == KEY_R:
			respawn()


func apply_gravity() -> void:
	if !is_on_floor():
		velocity += gravity_strength * -up_direction
	else:
		velocity = Vector2.ZERO


func do_jump(dir: Vector2) -> void:
	velocity = dir


func move() -> void:
	if Input.is_action_just_pressed("jump"):
		var jump_vec: Vector2 = up_direction * jump_strength

		print("jumping: num_air = ", num_air_jumps, " max_air = ", max_num_air_jumps)		
		if is_on_floor():
			num_air_jumps = 0
			do_jump(jump_vec)
		elif num_air_jumps < max_num_air_jumps:
			num_air_jumps += 1
			do_jump(jump_vec)

	var horizontal = Input.get_axis("move_left", "move_right")
	velocity.x = horizontal * move_speed
	
	
func set_checkpoint(checkpoint: Checkpoint) -> void:
	if current_checkpoint != null:
		current_checkpoint.dehighlight()
	current_checkpoint = checkpoint
	current_checkpoint.highlight()

	
func respawn() -> void:
	position = respawn_position
	velocity = Vector2.ZERO
	%Signaler.reset_signals()

	
func take_damage() -> void:
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
