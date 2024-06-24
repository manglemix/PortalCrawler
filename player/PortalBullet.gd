extends CharacterBody3D

@export var speed := 25

@onready var first = true

func _physics_process(delta: float) -> void:
	var data := move_and_collide(global_transform.basis.z * - speed * delta)
	
	if (first):
		first = false
		$CollisionShape3D.disabled = false
	if (data != null && data.get_collider().name != "Player"):
		queue_free()
