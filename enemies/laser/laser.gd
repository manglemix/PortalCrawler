class_name Laser
extends RayCast3D


@export var attack_delay := 0.5
@export var damage := 1

var _last_damager: Damageable
var _timer: float


func _physics_process(delta: float) -> void:
	$Body.visible = enabled
	if !enabled:
		return
	var length: float
	if is_colliding():
		length = get_collision_point().distance_to(global_position)
		var damager := Damageable.get_damageable_component(get_collider())
		if _last_damager == null or damager != _last_damager:
			_last_damager = damager
			_timer = attack_delay
		else:
			_timer -= delta
			if _timer <= 0:
				damager.damage_once(damage)
				_timer = attack_delay
			
	else:
		_last_damager = null
		length = target_position.length()
	$Body.scale.z = length
