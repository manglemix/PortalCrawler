@tool
class_name EnemyState
extends State


const MIN_NAV_RETARGET_DURATION := 200

var navigation: NavigationAgent3D
var player: CharacterBody3D

var _enemy: Enemy
var _shapecast: ShapeCast3D
var _last_nav_target_time := -MIN_NAV_RETARGET_DURATION
var _hiding_errors := false

var linear_velocity: Vector3:
	set = set_linear_velocity, get = get_linear_velocity
var global_transform: Transform3D:
	set = set_global_transform, get = get_global_transform
var transform: Transform3D:
	set = set_transform, get = get_transform


@warning_ignore("shadowed_variable")
func set_linear_velocity(linear_velocity: Vector3) -> void:
	if is_active():
		_enemy.velocity = linear_velocity
	elif !_hiding_errors:
		push_error("Cannot set linear_velocity of EnemyState if not active")


func get_linear_velocity() -> Vector3:
	return _enemy.velocity


@warning_ignore("shadowed_variable")
func set_global_transform(global_transform: Transform3D) -> void:
	if is_active():
		_enemy.global_transform = global_transform
	elif !_hiding_errors:
		push_error("Cannot set global_transform of EnemyState if not active")


func get_global_transform() -> Transform3D:
	return _enemy.global_transform


@warning_ignore("shadowed_variable")
func set_transform(transform: Transform3D) -> void:
	if is_active():
		_enemy.transform = transform
	elif !_hiding_errors:
		push_error("Cannot set transform of EnemyState if not active")


func get_transform() -> Transform3D:
	return _enemy.transform


@warning_ignore("shadowed_variable")
func set_navigation(navigation: NavigationAgent3D) -> void:
	self.navigation = navigation


@warning_ignore("shadowed_variable")
func set_player(player: Player) -> void:
	self.player = player


func set_enemy(enemy: Enemy) -> void:
	_enemy = enemy


func _enter() -> void:
	_last_nav_target_time = 0


func _exit() -> void:
	if navigation.velocity_computed.is_connected(set_linear_velocity):
		navigation.velocity_computed.disconnect(set_linear_velocity)


func set_navigation_target(target_position: Vector3) -> void:
	if Time.get_ticks_msec() - _last_nav_target_time < MIN_NAV_RETARGET_DURATION:
		return
	if !navigation.velocity_computed.is_connected(set_linear_velocity):
		navigation.velocity_computed.connect(set_linear_velocity)
	_last_nav_target_time = Time.get_ticks_msec()
	navigation.target_position = target_position


func navigate_to_next_path_position(speed: float) -> void:
	var next_pos := navigation.get_next_path_position()
	next_pos.y = global_transform.origin.y
	navigation.velocity = (next_pos - global_transform.origin).normalized() * speed
	if next_pos.distance_squared_to(global_transform.origin) > 0.05:
		look_at(next_pos)


func stop_navigation() -> void:
	if navigation.velocity_computed.is_connected(set_linear_velocity):
		navigation.velocity_computed.disconnect(set_linear_velocity)
	_last_nav_target_time = Time.get_ticks_msec()
	navigation.target_position = global_transform.origin
	linear_velocity = Vector3.ZERO


func look_at(position: Vector3) -> void:
	_enemy.look_at(position)


## fov is in radians
func is_player_in_sight(fov: float, min_radius: float) -> bool:
	if player == null:
		return false
	if (player.global_position - _enemy.global_position).angle_to(- _enemy.global_basis.z) > fov / 2.0:
		return false
	if _shapecast == null:
		return true
	
	_shapecast.target_position = Vector3.ZERO
	_shapecast.force_shapecast_update()
	if _shapecast.is_colliding():
		return _shapecast.get_collider(0) == player
	
	var target_position := player.global_position
	target_position.y = _shapecast.global_position.y
	_shapecast.target_position = _shapecast.to_local(target_position)
	if _shapecast.target_position.length() <= min_radius:
		return true
	_shapecast.force_shapecast_update()
	return _shapecast.get_collision_count() > 0 and _shapecast.get_collider(0) == player


func get_parent_origin() -> Vector3:
	return _enemy.get_parent_node_3d().position


func get_health() -> Health:
	return Health.get_health_component(_enemy)


func hide_errors() -> void:
	_hiding_errors = true


func unhide_errors() -> void:
	_hiding_errors = false


func set_shapecast(shapecast: ShapeCast3D) -> void:
	_shapecast = shapecast
