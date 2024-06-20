class_name LoopingTimer
extends Timer


@export var loops := 3

var _count := 0


func _ready():
	timeout.connect(
		func():
			_count += 1
			if _count == loops:
				_count = 0
				stop()
	)
