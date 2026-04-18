class_name Player
extends CharacterBody2D

@export var gravity_strength: float = 10
@export var move_speed: float = 300
@export var jump_strength: float = 400

@export var signal_settings: SignalerSettings

var original_position: Vector2
var current_checkpoint: Checkpoint = null

var respawn_position:
	get: return current_checkpoint.position if current_checkpoint != null else original_position

func _ready() -> void:
	original_position = position
	%Signaler.settings = signal_settings
	HUD.max_signal_uses = signal_settings.max_usage
	

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


func move() -> void:
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity = up_direction * jump_strength

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
