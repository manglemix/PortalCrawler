class_name BetaCollectibles
extends SaveDataFragment


static var has_godot_plushie := false
static var has_blender_plushie := false
static var has_aseprite_plushie := false


func _load_save_data(data: Dictionary) -> void:
	if "has_godot_plushie" in data:
		has_godot_plushie = data["has_godot_plushie"]
	if "has_blender_plushie" in data:
		has_blender_plushie = data["has_blender_plushie"]
	if "has_aseprite_plushie" in data:
		has_aseprite_plushie = data["has_aseprite_plushie"]


func _create_save_data(data: Dictionary) -> void:
	data["has_godot_plushie"] = has_godot_plushie
	data["has_blender_plushie"] = has_blender_plushie
	data["has_aseprite_plushie"] = has_aseprite_plushie
