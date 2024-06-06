class_name EnemyState
extends State


var navigation: NavigationAgent3D
var player: CharacterBody3D
var _enemy: Enemy

var linear_velocity: Vector3:
	set = set_linear_velocity, get = get_linear_velocity
var global_transform: Transform3D:
	set = set_global_transform, get = get_global_transform


@warning_ignore("shadowed_variable")
func set_linear_velocity(linear_velocity: Vector3) -> void:
	if is_active():
		_enemy.velocity = linear_velocity
	else:
		push_error("Cannot set linear_velocity of EnemyState if not active")


func get_linear_velocity() -> Vector3:
	return _enemy.velocity


@warning_ignore("shadowed_variable")
func set_global_transform(global_transform: Transform3D) -> void:
	if is_active():
		_enemy.global_transform = global_transform
	else:
		push_error("Cannot set global_transform of EnemyState if not active")


func get_global_transform() -> Transform3D:
	return _enemy.global_transform


@warning_ignore("shadowed_variable")
func set_navigation(navigation: NavigationAgent3D) -> void:
	self.navigation = navigation


@warning_ignore("shadowed_variable")
func set_player(player: CharacterBody3D) -> void:
	self.player = player


func set_enemy(enemy: Enemy) -> void:
	_enemy = enemy
