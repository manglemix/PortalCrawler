@tool
class_name AnimationStateMachine
extends Node3D

@export var damage_flash_duration := 0.2
@export var modulate := Color.WHITE:
	set=set_modulate

var _current_state: AnimationState


func set_modulate(color: Color) -> void:
	modulate = color
	for state in get_states():
		state.modulate = modulate


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	
	for child in get_children():
		if not child is AnimationState:
			warnings.append("%s is not an AnimationState" % child.name)
	
	return warnings


func get_states() -> Array[AnimationState]:
	var states: Array[AnimationState] = []
	for child in get_children():
		states.append(child)
	return states


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for state in get_states():
		state.hide()
		state.entered.connect(
			func():
				if _current_state != null:
					if _current_state.is_active():
						_current_state.exit()
					_current_state.hide()
				_current_state = state
		)
	
	if get_child_count() > 0:
		get_child(0).enter()


func damage_flash(_damage:=0):
	modulate = Color.RED
	create_tween().tween_property(self, "modulate", Color.WHITE, damage_flash_duration)
