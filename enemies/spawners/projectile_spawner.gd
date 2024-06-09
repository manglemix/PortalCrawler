class_name ProjectileSpawner
extends Spawner


@export var projectile: PackedScene
@export var max_spread_angle := 5.0


func spawn() -> void:
	var projectile_node: Node3D = projectile.instantiate()
	projectile_node.top_level = true
	projectile_node.tree_entered.connect(
		func():
			spawned.emit(projectile_node)
	)
	add_child(projectile_node)
	projectile_node.transform = global_transform
	projectile_node.transform.basis = projectile_node.transform.basis.rotated(Vector3.UP, (2 * randf() - 1) * deg_to_rad(max_spread_angle))
