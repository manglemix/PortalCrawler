extends CharacterBody3D

@export var speed := 50


func _physics_process(delta: float) -> void:
	var data := move_and_collide(global_transform.basis.z * - speed * delta)
	
	if data != null:
		queue_free()
