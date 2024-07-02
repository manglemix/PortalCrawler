class_name ScaleDown
extends Node


signal finished


func scale_down() -> void:
	var parent: Node3D = get_parent()
	await create_tween().tween_property(parent, "scale", Vector3.ZERO, 0.6).set_trans(Tween.TRANS_EXPO).finished
	finished.emit()
