extends Node


var _main_viewport: SubViewportContainer
var _collectible_viewport: SubViewportContainer


func get_collectible() -> PackedScene:
	if !BetaCollectibles.has_godot_plushie and randf() <= 0.2:
		return preload("res://collectibles/godot/godot.tscn")
	if !BetaCollectibles.has_aseprite_plushie and randf() <= 0.2:
		return preload("res://collectibles/aseprite/aseprite.tscn")
	if !BetaCollectibles.has_blender_plushie and randf() <= 0.2:
		return preload("res://collectibles/blender/blender.tscn")
	return preload("res://collectibles/money_bag/money_bag.tscn")


func _set_blur(strength: float) -> void:
	_main_viewport.material.set_shader_parameter("strength", strength)


func _set_brightness(brightness: float) -> void:
	_main_viewport.material.set_shader_parameter("brightness", brightness)


func move_to_collectible_viewport(node: Node) -> void:
	create_tween().tween_method(_set_blur, 0.0, 0.8, 1).set_trans(Tween.TRANS_EXPO)
	create_tween().tween_method(_set_brightness, 1.0, 0.6, 1).set_trans(Tween.TRANS_EXPO)
	node.reparent(_collectible_viewport.get_child(0).get_node("Foci"))


func clear_display() -> void:
	create_tween().tween_method(_set_blur, 0.8, 0.0, 1).set_trans(Tween.TRANS_EXPO)
	create_tween().tween_method(_set_brightness, 0.6, 1.0, 1).set_trans(Tween.TRANS_EXPO)
