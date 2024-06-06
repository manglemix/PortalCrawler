class_name BasicProjectile
extends CharacterBody3D

@export var speed := 2.5


func _physics_process(delta: float) -> void:
	var data := move_and_collide(global_transform.basis.z * - speed * delta)
	
	if data != null:
		Damageable.damage_node_once(data.get_collider(), 1)
		queue_free()
