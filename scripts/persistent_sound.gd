extends AudioStreamPlayer3D


func _ready():
	await get_tree().process_frame
	reparent(get_viewport())
	finished.connect(queue_free)
