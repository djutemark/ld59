extends Node

@export var allowed_time_seconds: float = 60 * 10

var total_elapsed_time_seconds: float
var total_num_jumps: int
var total_num_signals_made: int
var total_num_deaths: int
var is_tracking_elapsed_time: bool

func _ready() -> void:
	reset()

func _process(delta: float) -> void:
	if is_tracking_elapsed_time:
		total_elapsed_time_seconds += delta

func reset() -> void:
	total_elapsed_time_seconds = 0.0
	total_num_jumps = 0
	total_num_signals_made = 0
	total_num_deaths = 0
	is_tracking_elapsed_time = true
