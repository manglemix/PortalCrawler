extends Node


var _difficulty := 0


func get_difficulty() -> int:
	return _difficulty


func change_difficulty(value: int) -> void:
	_difficulty += value
