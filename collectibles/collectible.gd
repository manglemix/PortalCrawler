class_name Collectible
extends RigidBody3D

@export var speed := 6.0

func _ready() -> void:
	max_contacts_reported = 1
	contact_monitor = true
	linear_velocity = global_basis.z * - speed
	
	while true:
		var body: Node = await body_entered
		if body is Player:
			queue_free()
