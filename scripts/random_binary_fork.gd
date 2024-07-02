class_name RandomBinaryFork
extends Node


signal signal1
signal signal2


@export var probability := 0.5


func emit() -> void:
	if randf() <= probability:
		signal1.emit()
	else:
		signal2.emit()
