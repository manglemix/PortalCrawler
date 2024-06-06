@tool
class_name EnemyStateMachine
extends StateMachine


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
