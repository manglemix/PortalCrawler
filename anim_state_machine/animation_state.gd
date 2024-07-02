class_name AnimationState
extends AnimatedSprite3D


signal entered
signal exited


func is_active() -> bool:
	return visible


func enter() -> void:
	var was_active := is_active()
	show()
	_enter()
	if !was_active:
		entered.emit()


func _enter() -> void:
	play(animation)
	await animation_finished
	exit()


func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	
	if Engine.is_editor_hint():
		return
	
	if !has_node("YSort"):
		add_child(YSort.new())


func _exit() -> void:
	pause()


func exit() -> void:
	if !is_active():
		return
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	exited.emit()
	_exit()
