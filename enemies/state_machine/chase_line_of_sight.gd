@tool
class_name Chase
extends EnemyState


signal lost_player(last_position: Vector3)
signal player_position(position: Vector3)

@export var chase_speed := 0.9
@export var fov := 190.0
@export var min_distance := 1.0
@export var line_of_sight_check := true


func _enter() -> void:
	super()
	set_physics_process(true)
	set_navigation_target(player.global_position)
	navigate_to_next_path_position(chase_speed)


func _physics_process(_delta: float) -> void:
	if player != null and (!line_of_sight_check or is_player_in_sight(deg_to_rad(fov), 1.5)):
		player_position.emit(player.global_position)
		set_navigation_target(player.global_position)
	else:
		exit(lost_player)
		return
		
	if navigation.is_navigation_finished():
		set_navigation_target(player.global_position)
	
	if player.global_position.distance_to(global_transform.origin) <= min_distance:
		navigate_to_next_path_position(0)
	else:
		navigate_to_next_path_position(chase_speed)
