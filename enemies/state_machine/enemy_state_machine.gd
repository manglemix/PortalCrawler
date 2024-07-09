@tool
class_name EnemyStateMachine
extends StateMachine


@export var shapecast: ShapeCast3D

var _enemy: Enemy


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	for child in get_children():
		if not child is EnemyState:
			warnings.append("%s is not an EnemyState" % child.name)
	
	return warnings


func get_enemy_states() -> Array[EnemyState]:
	var states: Array[EnemyState] = []
	for child in get_children():
		states.append(child)
	return states


func set_player(player: CharacterBody3D) -> void:
	for state in get_enemy_states():
		state.set_player(player)


func set_enemy(enemy: Enemy) -> void:
	_enemy = enemy
	for state in get_enemy_states():
		state.set_enemy(enemy)


func set_navigation(navigation: NavigationAgent3D) -> void:
	for state in get_enemy_states():
		state.set_navigation(navigation)


func _ready() -> void:
	for state in get_enemy_states():
		state.set_shapecast(shapecast)
	super()
