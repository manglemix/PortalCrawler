@tool
extends EnemyState


signal player_position(position: Vector3)
signal attack_finished

const DURATION := 3.0
const DELAY := 0.3


func _enter() -> void:
	super()
	stop_navigation()
	set_physics_process(true)
	player_position.emit(player.global_position)
	look_at(player.global_position)
	get_tree().create_timer(DURATION, false).timeout.connect(exit.bind(attack_finished))


func _physics_process(_delta: float) -> void:
	var pos := player.global_position
	await get_tree().create_timer(DELAY, false).timeout
	if is_active():
		player_position.emit(pos)
		look_at(pos)
