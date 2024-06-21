extends AudioStreamPlayer3D


func _ready():
	await get_tree().process_frame
	reparent(get_viewport())
	play()
	await finished
	queue_free()
