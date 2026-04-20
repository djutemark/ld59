extends Container


func _ready() -> void:
	if OS.has_feature("web"):
		(%QuitGameButton as Button).visible = false


func _on_start_game_button_button_down() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_game_button_button_down() -> void:
	get_tree().quit()
