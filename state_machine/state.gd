@tool
class_name State
extends Node


signal entered
signal exited

@export var pullable_from: Array[State] = []:
	set(x):
		pullable_from = x
		update_configuration_warnings()

var _active := false
var _pullable_states: Array[State]


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	
	for state in pullable_from:
		if state == null:
			warnings.append("Pullable from cannot contain a null")
			continue
		if !state.get_parent() == get_parent():
			warnings.append("%s is not from the same state machine" % state.name)
	
	return warnings


func is_active() -> bool:
	return _active


## The entry point to this State.[br]
## [br]
## Should not be called while the State is already active. DO NOT override.
## Instead, override [method _enter].
func enter() -> void:
	_active = true
	_enter()
	entered.emit()


func _enter() -> void:
	push_error("unimplemented")


func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	
	
	
	if Engine.is_editor_hint():
		return
	
	for state in pullable_from:
		state.on_pull_request(self)


func _exit() -> void:
	pass


func _exit_internal() -> void:
	_active = false
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	exited.emit()
	_exit()


func exit(exit_signal: Signal) -> void:
	if !is_active():
		return
	_exit_internal()
	if exit_signal != null:
		exit_signal.emit()


func on_pull_request(other: State) -> void:
	_pullable_states.append(other)


func pull_state() -> void:
	if is_active():
		return
	var i := 0
	while i < _pullable_states.size():
		var state := _pullable_states[i]
		if !is_instance_valid(state):
			_pullable_states.remove_at(i)
			continue
		if state.is_active():
			if state.can_pull():
				state.exited.connect(enter, CONNECT_ONE_SHOT)
				state._exit_internal()
			break
		i += 1


func can_pull() -> bool:
	return true
