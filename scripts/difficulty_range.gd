class_name DifficultyRange
extends Node


@export var min_difficulty := 0
@export var max_difficulty := 10


func _ready() -> void:
	if GameState.get_difficulty() < min_difficulty or GameState.get_difficulty() > max_difficulty:
		queue_free()
