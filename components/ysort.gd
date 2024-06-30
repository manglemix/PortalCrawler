@tool
class_name YSort
extends Node


const DIVISIONS := Material.RENDER_PRIORITY_MAX - 1

@onready var sprite: SpriteBase3D = get_parent()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	if not get_parent() is SpriteBase3D:
		warnings.append("Parent is not a sprite")
	return warnings


func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)
		return
	set_process(sprite.no_depth_test)


func _process(_delta: float) -> void:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var screen_pos := camera.unproject_position(sprite.global_position)
	var priority := roundi(screen_pos.y / (get_viewport().size.y / DIVISIONS)) + 1
	sprite.render_priority = clampi(priority, 1, Material.RENDER_PRIORITY_MAX)
