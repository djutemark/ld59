extends Node

var total_elapsed_time_seconds: float = 0.0
var total_num_jumps := 0
var total_num_signals_made := 0

func _process(delta: float) -> void:
	total_elapsed_time_seconds += delta
