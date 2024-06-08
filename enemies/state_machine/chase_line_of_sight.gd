class_name ChaseLineOfSight
extends EnemyState


signal lost_player(last_position: Vector3)

@export var chase_speed := 0.9
@export var fov := 180.0

var _last_position: Vector3


func _enter(_data) -> void:
	set_physics_process(true)
	set_navigation_target(player.global_position)


func _physics_process(_delta: float) -> void:
	if is_player_in_sight(deg_to_rad(fov), 0.5):
		_last_position = player.global_position
		set_navigation_target(_last_position)
	else:
		exit(lost_player, _last_position)
		return
		
	if navigation.is_navigation_finished():
		_last_position = player.global_position
		set_navigation_target(_last_position)
	
	navigate_to_next_path_position(chase_speed)
