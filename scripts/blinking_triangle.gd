extends Sprite2D

func _ready() -> void:
	var t := get_tree().create_tween()
	t.tween_property(self, "modulate:a", 0, 0)
	t.tween_property(self, "modulate:a", 0, 0.2)
	t.tween_property(self, "modulate:a", 1, 0)
	t.tween_property(self, "modulate:a", 1, 0.4)
	t.set_loops()
