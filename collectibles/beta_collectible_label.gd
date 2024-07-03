extends Label


func _ready() -> void:
	var count := 1
	if BetaCollectibles.has_aseprite_plushie:
		count += 1
	if BetaCollectibles.has_godot_plushie:
		count += 1
	if BetaCollectibles.has_blender_plushie:
		count += 1
	text += "\n%s/3 easter eggs" % count
