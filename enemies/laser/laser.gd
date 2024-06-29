class_name Laser
extends RayCast3D


@export var initial_attack_delay := 0.1
@export var attack_delay := 0.5
@export var damage := 1

var _last_damager: Damageable
var _timer: float


func _physics_process(delta: float) -> void:
	enabled = is_visible_in_tree()
	$Body.visible = enabled
	if !enabled:
		return
	var length: float
	if is_colliding():
		length = get_collision_point().distance_to(global_position)
		var damager := Damageable.get_damageable_component(get_collider())
		if _last_damager == null or damager != _last_damager:
			_last_damager = damager
			_timer = initial_attack_delay
		else:
			_timer -= delta
			if _timer <= 0:
				damager.damage_once(damage, self)
				_timer = attack_delay
			
	else:
		_last_damager = null
		length = target_position.length()
	$Body.scale.z = length


func aim_at(target: Vector3, up: Vector3 = Vector3(0, 1, 0)) -> void:
	target.y = global_position.y
	look_at(target, up)
