class_name FadeIn
extends Node


@export var duration := 0.6


func _ready() -> void:
	get_parent().modulate.a = 0.0


func fade_in() -> void:
	var parent: Node = get_parent()
	create_tween().tween_property(parent, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_EXPO)
