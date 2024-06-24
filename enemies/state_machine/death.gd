@tool
class_name DeathState
extends EnemyState


func _enter() -> void:
	stop_navigation()


func _on_died() -> void:
	pull_state()
