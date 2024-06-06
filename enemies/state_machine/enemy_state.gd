class_name EnemyState
extends State


const MIN_NAV_RETARGET_DURATION := 500

var navigation: NavigationAgent3D
var player: CharacterBody3D

var _enemy: Enemy
var _raycast: RayCast3D
var _last_nav_target_time: int

var linear_velocity: Vector3:
	set = set_linear_velocity, get = get_linear_velocity
var global_transform: Transform3D:
	set = set_global_transform, get = get_global_transform


func _ready() -> void:
	super()
	_raycast = RayCast3D.new()
	# Should be the same as the Player layer
	_raycast.collision_mask += 2
	add_child(_raycast)
	_raycast.enabled = false


@warning_ignore("shadowed_variable")
func set_linear_velocity(linear_velocity: Vector3) -> void:
	if is_active():
		_enemy.velocity = linear_velocity
	else:
		push_error("Cannot set linear_velocity of EnemyState if not active")


func get_linear_velocity() -> Vector3:
	return _enemy.velocity


@warning_ignore("shadowed_variable")
func set_global_transform(global_transform: Transform3D) -> void:
	if is_active():
		_enemy.global_transform = global_transform
	else:
		push_error("Cannot set global_transform of EnemyState if not active")


func get_global_transform() -> Transform3D:
	return _enemy.global_transform


@warning_ignore("shadowed_variable")
func set_navigation(navigation: NavigationAgent3D) -> void:
	self.navigation = navigation


@warning_ignore("shadowed_variable")
func set_player(player: CharacterBody3D) -> void:
	self.player = player


func set_enemy(enemy: Enemy) -> void:
	_enemy = enemy


func enter() -> void:
	navigation.velocity_computed.connect(set_linear_velocity)
	super()


func exit(exit_signal: Signal) -> void:
	navigation.velocity_computed.disconnect(set_linear_velocity)
	super(exit_signal)


func set_navigation_target(target_position: Vector3) -> void:
	if Time.get_ticks_msec() - _last_nav_target_time < MIN_NAV_RETARGET_DURATION:
		return
	_last_nav_target_time = Time.get_ticks_msec()
	navigation.target_position = target_position


func navigate_to_next_path_position(speed: float) -> void:
	navigation.velocity = (navigation.get_next_path_position() - global_transform.origin).slide(Vector3.UP).normalized() * speed


func is_player_in_sight() -> bool:
	if player == null:
		return false
	_raycast.global_transform = _enemy.global_transform
	_raycast.global_position.y = 0.1
	_raycast.target_position = _raycast.to_local(player.global_position)
	_raycast.target_position.y = 0.1
	_raycast.force_raycast_update()
	return _raycast.get_collider() == player
