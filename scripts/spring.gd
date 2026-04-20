extends Area2D

@export var jump_strength: float = 200

var anim: AnimatedSprite2D

func _ready() -> void:
	anim = %Anim as AnimatedSprite2D
	anim.sprite_frames.set_animation_loop("jump", false)
	anim.sprite_frames.set_animation_loop("idle", false)
	anim.play("idle")


func _on_body_entered(body: Node2D) -> void:
	var p := body as Player
	if p:
		p.do_jump(Vector2.UP * jump_strength)
		p.reset_air_jumps()
		anim.play("jump")
		await anim.animation_finished
		anim.play("idle")
