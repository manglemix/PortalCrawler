@tool
class_name ChaseLastPosition
extends EnemyState


signal player_spotted
signal lost_player

@export var chase_speed := 0.9
@export var fov := 180.0
@export var min_distance := 1.0

var _last_position: Vector3


func set_last_position(pos: Vector3) -> void:
	_last_position = pos


func _enter() -> void:
	super()
	set_physics_process(true)
	set_navigation_target(_last_position)


func _physics_process(_delta: float) -> void:
	if is_player_in_sight(deg_to_rad(fov), 1.5):
		exit(player_spotted)
		return
	
	if navigation.is_navigation_finished():
		exit(lost_player)
		return
	
	if player.global_position.distance_to(global_transform.origin) <= min_distance:
		linear_velocity = Vector3.ZERO
		look_at(player.global_position)
	else:
		navigate_to_next_path_position(chase_speed)
