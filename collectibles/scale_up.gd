class_name ScaleUp
extends Node


func _ready() -> void:
	var parent: Node3D = get_parent()
	var final_scale := parent.scale
	parent.scale = Vector3.ZERO
	create_tween().tween_property(parent, "scale", final_scale, 0.6).set_trans(Tween.TRANS_EXPO)
