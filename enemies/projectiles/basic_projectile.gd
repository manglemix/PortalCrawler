class_name BasicProjectile
extends CharacterBody3D

const MAX_DURATION := 10.0

@export var speed := 4.5

var _first_frame := true


func _ready():
	get_tree().create_timer(MAX_DURATION, false).timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	var data := move_and_collide(global_transform.basis.z * - speed * delta)
	
	if data == null:
		if _first_frame:
			for node in get_collision_exceptions():
				remove_collision_exception_with(node)
		_first_frame = false
		
	else:
		if (data.get_collider().name.begins_with("portal")):
			return
		var damageable := Damageable.get_damageable_component(data.get_collider())
		if damageable == null:
			if _first_frame:
				add_collision_exception_with(data.get_collider())
				return
		else:
			damageable.damage_once(1)
		queue_free()
	
