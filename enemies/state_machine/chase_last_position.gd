class_name ChaseLastPosition
extends EnemyState


signal player_spotted
signal lost_player

@export var chase_speed := 0.9
@export var fov := 180.0


func _enter(data) -> void:
	set_physics_process(true)
	set_navigation_target(data)


func _physics_process(_delta: float) -> void:
	if is_player_in_sight(deg_to_rad(fov), 0.5):
		exit(player_spotted)
		return
	
	if navigation.is_navigation_finished():
		exit(lost_player)
		return
	
	navigate_to_next_path_position(chase_speed)
