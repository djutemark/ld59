extends Control


func _ready() -> void:
	%StatsText.text = _build_stats_text()


func _on_to_main_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")


func _build_stats_text() -> String:
	var text := PackedStringArray()
	
	var did_time_run_out = Stats.total_elapsed_time_seconds > Stats.allowed_time_seconds
	var game_result_text := ""
	if did_time_run_out:
		game_result_text += "The time ran out!"
	else:
		text.append("You won!")
		game_result_text += "Total time: %s" % HUD.seconds_to_display(Stats.total_elapsed_time_seconds)
	text.append(game_result_text)
	
	text.append("Total jumps: %d" % Stats.total_num_jumps)
	text.append("Total signals used: %d" % Stats.total_num_signals_made)
	text.append("Total respawns: %d" % Stats.total_num_deaths)
	
	return "\n".join(text)
