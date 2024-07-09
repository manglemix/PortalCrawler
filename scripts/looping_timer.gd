class_name LoopingTimer
extends Timer


signal looping_ended

@export var loops := 3

var _count := 0


func _ready():
	timeout.connect(
		func():
			_count += 1
			if _count == loops:
				_count = 0
				stop()
				looping_ended.emit()
	)


func reset_count() -> void:
	_count = 0
