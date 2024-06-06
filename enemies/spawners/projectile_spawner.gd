class_name ProjectileSpawner
extends Marker3D


@export var projectile: PackedScene
@export var max_spread_angle := 5.0


func spawn() -> void:
	var projectile_node: Node3D = projectile.instantiate()
	projectile_node.top_level = true
	add_child(projectile_node)
	projectile_node.transform = global_transform
	projectile_node.transform.basis = projectile_node.transform.basis.rotated(Vector3.UP, (2 * randf() - 1) * deg_to_rad(max_spread_angle))
