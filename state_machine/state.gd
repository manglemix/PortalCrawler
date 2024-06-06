class_name State
extends Node
## A State represents logic that can be executed in a state machine.[br]
## 
## A set of States comprise a state machine.
## States should define signals that will be emitted when the State terminates.
## Users of a State should connect these signals to the [method enter] methods of
## other States to form transisitions. If a signal is not connected, the State
## has the ability to terminate the entire state machine if it emits that signal.
## If a State does not have any signals, or does not emit any of its existing signals,
## it will keep the state machine stuck in that State.[br]
## [br]
## If none of the [method enter] method's are called, the state machine does not start.
## As such, one State should be picked as the starting State, and that State should
## have its [method enter] method be called.


signal entered
signal exited

var _active := false


func is_active() -> bool:
	return _active


## The entry point to this State.[br]
## [br]
## Should not be called while the State is already active. DO NOT override.
## Instead, override [method _enter].
func enter(data=null) -> void:
	_active = true
	_enter(data)
	entered.emit()


func _enter(_data) -> void:
	push_error("unimplemented")


func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)


func exit(exit_signal: Signal, data=null) -> void:
	_active = false
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	await get_tree().process_frame
	exit_signal.emit(data)
	exited.emit()
