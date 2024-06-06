class_name Wander
extends EnemyState


signal player_entered

@export var wander_speed := 1.0


func _enter() -> void:
	set_physics_process(true)
	_random_target()
	navigation.velocity_computed.connect(
		func(safe_velocity: Vector3):
			velocity_computed.emit(safe_velocity)
	)


@warning_ignore("shadowed_variable")
func set_player(player: CharacterBody3D) -> void:
	super(player)
	if player != null:
		await get_tree().process_frame
		player_entered.emit()


func _random_target() -> void:
	navigation.target_position = global_transform.origin + Vector3.RIGHT.rotated(Vector3.UP, randf() * TAU) * randf_range(1.0, 4.0)


func _physics_process(_delta: float) -> void:
	if navigation.is_navigation_finished():
		_random_target()
	navigation.velocity = global_transform.origin.direction_to(navigation.get_next_path_position()) * wander_speed
