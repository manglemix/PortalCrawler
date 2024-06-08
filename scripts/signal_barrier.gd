class_name SignalBarrier
extends Node


signal passed


@export var barrier_count := 1

var _counter := 0


func receive() -> void:
	_counter += 1
	if _counter == barrier_count:
		passed.emit()


func reset() -> void:
	_counter = 0
