class_name Signaler
extends Area2D

@export var settings: SignalerSettings

var is_active: bool = false
var current_visible_invisibiles: Array[Invisibility] = []

const RADIUS_SPRITE_RATIO = 0.5 # Very much a magic number

func _ready() -> void:
	%SignalHitbox.disabled = true


func make_signal() -> void:
	if is_active:
		return
	is_active = true

	var shape: CircleShape2D = %SignalHitbox.shape
	if shape != null:
		%PulseSprite.scale = Vector2.ZERO
		%SignalHitbox.disabled = false
		shape.radius = 0
		var t = create_tween()
		t.set_parallel(true)
		t.set_trans(settings.growth_type)
		t.tween_property(shape, "radius", settings.max_radius, settings.grow_duration)
		t.tween_property(%PulseSprite, "scale", RADIUS_SPRITE_RATIO * Vector2(settings.max_radius, settings.max_radius), settings.grow_duration)
		await t.finished
		await get_tree().create_timer(settings.time_at_max_growth).timeout
		%SignalHitbox.disabled = true
		
		for invisibility in current_visible_invisibiles:
			invisibility.make_invisible()
		current_visible_invisibiles.clear()
	is_active = false


func _on_body_entered(body: Node2D) -> void:
	var invisibilities = body.find_children("*", "Invisibility", false)
	
	if invisibilities.size() > 0:
		var invisible_node = invisibilities[0] as Invisibility
		invisible_node.make_visible()
		current_visible_invisibiles.append(invisible_node)
