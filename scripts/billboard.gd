@tool
class_name Billboard
extends Node3D


func _get_configuration_warnings():
	var warnings := []
	
	if !get_parent() is Node3D:
		warnings.append("Parent must be a Node3D")
	
	if !top_level:
		warnings.append("top_level must be true (reload scene)")
	
	return warnings


func _ready():
	set_process(!Engine.is_editor_hint())


func _process(_delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	var parent: Node3D = get_parent()
	look_at_from_position(parent.global_position, camera.global_position, camera.global_basis.y)
