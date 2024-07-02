class_name CollectibleSpawner
extends Spawner


signal collectible_collected


@export var collectible: PackedScene = null
@export var max_spread_angle := 45.0


func spawn() -> void:
	var projectile_node: Node3D
	if collectible == null:
		projectile_node = Collectibles.get_collectible().instantiate()
	else:
		projectile_node = collectible.instantiate()
	projectile_node.top_level = true
	projectile_node.tree_entered.connect(
		func():
			spawned.emit(projectile_node)
	)
	projectile_node.tree_exited.connect(
		func():
			collectible_collected.emit()
	)
	projectile_node.transform.basis = projectile_node.transform.basis.rotated(Vector3.RIGHT, randf_range(PI / 2 - deg_to_rad(max_spread_angle / 2), PI / 2))
	projectile_node.transform.basis = projectile_node.transform.basis.rotated(Vector3.UP, randf_range(0, TAU))
	add_child(projectile_node)
