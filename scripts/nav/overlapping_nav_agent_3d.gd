class_name OverlappingNavAgent3D
extends NavigationAgent3D


@export var index: int


func _ready() -> void:
	set_navigation_map(NavigationServer3D.get_maps()[index])
	avoidance_priority = randf()
