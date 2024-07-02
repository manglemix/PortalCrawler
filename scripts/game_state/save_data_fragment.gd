class_name SaveDataFragment
extends Node


func _ready() -> void:
	await get_tree().process_frame
	reparent(GameState)


func _load_save_data(_data: Dictionary) -> void:
	push_error("Unimplemented")


func _create_save_data(_data: Dictionary) -> void:
	push_error("Unimplemented")
