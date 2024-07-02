@tool
class_name Billboard
extends Node3D


var  _first_frame := true


func _get_configuration_warnings():
	var warnings := []
	
	if !get_parent() is Node3D:
		warnings.append("Parent must be a Node3D")
	
	if !top_level:
		warnings.append("top_level must be true (reload scene)")
	
	return warnings


func _ready():
	if Engine.is_editor_hint():
		set_process(false)
	else:
		hide()


func _process(_delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	var parent: Node3D = get_parent()
	look_at_from_position(parent.global_position, camera.global_position, camera.global_basis.y)
	if _first_frame:
		show()
		_first_frame = false
