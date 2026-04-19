class_name Signaler
extends Area2D

@export var settings: SignalerSettings:
	get:
		return settings
	set(value):
		settings = value
		HUD.max_signal_uses = value.max_usage

var is_active: bool = false
var current_visible_invisibiles: Array[Invisibility] = []
var num_uses: int = 0

const RADIUS_SPRITE_RATIO = 0.5 # Very much a magic number

func _ready() -> void:
	%SignalHitbox.disabled = true


func make_signal() -> void:
	if is_active or num_uses >= settings.max_usage:
		return
	is_active = true
	num_uses += 1
	HUD.current_signal_uses = num_uses

	var shape: CircleShape2D = %SignalHitbox.shape
	if shape != null:
		Audio.play(Audio.Sound.SignalPulse)
		Stats.total_num_signals_made += 1
		%PulseSprite.scale = Vector2.ZERO
		%SignalHitbox.disabled = false
		shape.radius = 0
		var t = create_tween()
		t.set_parallel(true)
		t.set_trans(settings.growth_type)
		t.set_ease(Tween.EASE_OUT)
		t.tween_property(shape, "radius", settings.max_radius, settings.grow_duration)
		t.tween_property(%PulseSprite, "scale", RADIUS_SPRITE_RATIO * Vector2(settings.max_radius, settings.max_radius), settings.grow_duration)
		await t.finished
		await get_tree().create_timer(settings.time_at_max_growth).timeout
		%SignalHitbox.disabled = true
		%PulseSprite.scale = Vector2.ZERO
	
		for invisibility in current_visible_invisibiles:
			# We might already have removed the thihng to make invisible
			if is_instance_valid(invisibility):
				invisibility.make_invisible()
		current_visible_invisibiles.clear()
		
		await get_tree().create_timer(settings.cooldown).timeout
	is_active = false


func reset_signals() -> void:
	num_uses = 0
	HUD.current_signal_uses = num_uses


func try_activate_invisibility(other: Node2D) -> void:
	var invisible_node: Invisibility = Invisibility.try_get_invisibility(other)
	
	if invisible_node != null:
		invisible_node.make_visible()
		current_visible_invisibiles.append(invisible_node)

func _on_body_entered(body: Node2D) -> void:
	try_activate_invisibility(body)


func _on_area_entered(area: Area2D) -> void:
	try_activate_invisibility(area)
