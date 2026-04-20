extends HFlowContainer


func _on_start_game_button_button_down() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
