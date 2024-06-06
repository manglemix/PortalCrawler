class_name Wander
extends EnemyState


signal player_spotted

@export var wander_speed := 0.75



func _enter() -> void:
	set_physics_process(true)
	_random_target()


func _random_target() -> void:
	set_navigation_target(global_transform.origin + Vector3.RIGHT.rotated(Vector3.UP, randf() * TAU) * randf_range(2.0, 7.0))


func _physics_process(_delta: float) -> void:
	if is_player_in_sight():
		exit(player_spotted)
		return
	if navigation.is_navigation_finished():
		_random_target()
	navigate_to_next_path_position(wander_speed)
