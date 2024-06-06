class_name ChaseLineOfSight
extends EnemyState


signal lost_player

@export var chase_speed := 0.9


func _enter() -> void:
	set_physics_process(true)
	set_navigation_target(player.global_position)


func _physics_process(_delta: float) -> void:
	if is_player_in_sight():
		set_navigation_target(player.global_position)
	else:
		exit(lost_player)
		return
		
	if navigation.is_navigation_finished():
		navigation.target_position = player.global_position
	
	navigate_to_next_path_position(chase_speed)
