extends EnemyState


@export var delay := 1.0


func _on_damaged(_damage: int) -> void:
	if !is_active():
		pull_state()
