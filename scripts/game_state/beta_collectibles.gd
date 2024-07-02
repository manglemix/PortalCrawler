class_name BetaCollectibles
extends SaveDataFragment


static var has_godot_plushie := false


func _load_save_data(data: Dictionary) -> void:
	if "has_godot_plushie" in data:
		has_godot_plushie = data["has_godot_plushie"]


func _create_save_data(data: Dictionary) -> void:
	data["has_godot_plushie"] = has_godot_plushie
