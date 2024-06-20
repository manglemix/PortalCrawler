class_name Death
extends EnemyState


func _enter() -> void:
	set_navigation_target(global_transform.origin)
	linear_velocity = Vector3.ZERO


func _on_died() -> void:
	pull_state()
