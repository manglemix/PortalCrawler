@tool
class_name WaitForPlayer
extends EnemyState


signal player_received


@warning_ignore("shadowed_variable")
func set_player(player: Player) -> void:
	super(player)
	player_received.emit(player)
