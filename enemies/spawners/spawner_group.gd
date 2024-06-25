class_name SpawnerGroup
extends Spawner


func spawn() -> void:
	for child in get_children():
		if child is Spawner:
			child.spawn()
