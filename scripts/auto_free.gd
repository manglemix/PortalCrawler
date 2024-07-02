class_name AutoFree
extends Node


func _ready() -> void:
	await get_tree().process_frame
	while get_child_count() > 0:
		await child_exiting_tree
	queue_free()
