extends Node


var _play_time := 0.0


func _process(delta):
	_play_time += delta


func get_play_time() -> float:
	return _play_time
