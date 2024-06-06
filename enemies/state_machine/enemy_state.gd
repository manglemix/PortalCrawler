class_name EnemyState
extends State


signal velocity_computed(velocity: Vector3)

var navigation: NavigationAgent3D
var player: CharacterBody3D
var _enemy: Enemy

var global_transform: Transform3D:
	set(_x):
		push_error("Cannot set global_transform of EnemyState")
	get:
		return _enemy.global_transform


@warning_ignore("shadowed_variable")
func set_navigation(navigation: NavigationAgent3D) -> void:
	self.navigation = navigation


@warning_ignore("shadowed_variable")
func set_player(player: CharacterBody3D) -> void:
	self.player = player


func set_enemy(enemy: Enemy) -> void:
	_enemy = enemy
