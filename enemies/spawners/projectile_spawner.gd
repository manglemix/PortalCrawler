class_name ProjectileSpawner
extends Spawner


@export var projectile: PackedScene
@export var max_spread_angle := 5.0
@export var spawn_on_root := true

@export var rotate_y_only := true


func aim_at(target: Vector3, up: Vector3 = Vector3(0, 1, 0)) -> void:
	if rotate_y_only:
		target.y = global_position.y
	look_at(target, up)


func spawn() -> void:
	var projectile_node: Node3D = projectile.instantiate()
	projectile_node.top_level = true
	projectile_node.tree_entered.connect(
		func():
			spawned.emit(projectile_node)
	)
	if spawn_on_root:
		get_tree().current_scene.add_child(projectile_node)
	else:
		add_child(projectile_node)
	projectile_node.transform = global_transform
	projectile_node.transform.basis = projectile_node.transform.basis.rotated(Vector3.UP, (2 * randf() - 1) * deg_to_rad(max_spread_angle))
