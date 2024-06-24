@tool
extends EnemyState


signal tired_finished

const DURATION := 3.0



func _enter() -> void:
	super()
	stop_navigation()
	transform.origin = Vector3(lerpf(-5.5, 5.5, randf()), 0, lerpf(-2.6, 2.6, randf()))
	get_tree().create_timer(DURATION, false).timeout.connect(exit.bind(tired_finished))
