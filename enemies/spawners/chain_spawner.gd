class_name ChainSpawner
extends Spawner


@export var axis := Vector3.UP
@export var count := 12
@export var step := 30.0


func spawn() -> void:
	var spawner: Spawner = get_child(0)
	for _i in range(count):
		spawner.spawn()
		spawner.global_rotate(axis, deg_to_rad(step))
