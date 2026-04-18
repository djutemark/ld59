class_name Player
extends CharacterBody2D

@export var gravity_strength: float = 10
@export var move_speed: float = 300
@export var jump_strength: float = 400

var start_position: Vector2

func _ready() -> void:
	start_position = position


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use_signaler"):
		Signaler.make_visible.emit()


func _physics_process(_delta: float) -> void:
	apply_gravity()
	move()
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		if event.keycode == KEY_R:
			position = start_position
			velocity = Vector2.ZERO


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
	

func take_damage() -> void:
	# TODO: Teleport to last checkpoint here	
	pass	
