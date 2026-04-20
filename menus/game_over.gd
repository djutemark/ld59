extends Control

@export var game_lost_sound: AudioStream
@export var game_won_sound: AudioStream

var player_did_win: bool

func _ready() -> void:
	player_did_win = Stats.total_elapsed_time_seconds < Stats.allowed_time_seconds

	(%StatsText as Label).text = _build_stats_text()
	Audio._create_and_play_stream(game_won_sound if player_did_win else game_lost_sound)


func _on_to_main_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")


func _build_stats_text() -> String:
	var text := PackedStringArray()

	(%GameOverLabel as Label).text = "You won!" if player_did_win else "Game Over!"
	
	var game_result_text := ""
	if player_did_win:
		game_result_text += "Total time: %s" % HUD.seconds_to_display(Stats.total_elapsed_time_seconds)
	else:
		game_result_text += "The time ran out!"
	text.append(game_result_text)
	
	text.append("Total jumps: %d" % Stats.total_num_jumps)
	text.append("Total signals used: %d" % Stats.total_num_signals_made)
	text.append("Total respawns: %d" % Stats.total_num_deaths)
	
	return "\n".join(text)
