class_name BasicProjectile
extends CharacterBody3D

const MAX_DURATION := 10.0
const NOCLIP_DURATION := 0.2

@export var speed := 4.5
@export var damage := 1

var _noclip_timer := NOCLIP_DURATION
var _noclipping := true
var _attacking_enemies := false


func _ready():
	get_tree().create_timer(MAX_DURATION, false).timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	var data := move_and_collide(global_transform.basis.z * - speed * delta)
	
	if data != null:
		if (data.get_collider().name.begins_with("portal")):
			return
		var damageable := Damageable.get_damageable_component(data.get_collider())
		if damageable == null:
			if _noclipping:
				add_collision_exception_with(data.get_collider())
			else:
				queue_free()
		else:
			damageable.damage_once(damage)
			queue_free()
	
	if _noclipping:
		_noclip_timer -= delta
		if _noclip_timer <= 0.0:
			for node in get_collision_exceptions():
				remove_collision_exception_with(node)
			_noclipping = false


func attack_enemies() -> void:
	if !_attacking_enemies:
		collision_mask += 4
		_attacking_enemies = true
