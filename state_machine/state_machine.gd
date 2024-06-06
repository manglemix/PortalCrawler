@tool
class_name StateMachine
extends Node


@export var enter_on_ready := false


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	
	for child in get_children():
		if not child is State:
			warnings.append("%s is not a State" % child.name)
	
	return warnings


func _ready():
	if Engine.is_editor_hint():
		child_entered_tree.connect(
			func(_node):
				update_configuration_warnings()
		)
		child_exiting_tree.connect(
			func(_node):
				update_configuration_warnings()
		)
		update_configuration_warnings()
	
	if enter_on_ready:
		enter()


func get_states() -> Array[State]:
	var states: Array[State] = []
	for child in get_children():
		states.append(child)
	return states


func enter():
	get_child(0).enter()
