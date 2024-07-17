extends Node3D

@export var speed := 25

@onready var raycast: RayCast3D = $RayCast3D

func _ready() -> void:
	raycast.target_position *= get_physics_process_delta_time() * speed

func _physics_process(delta: float) -> void:
	global_position -= global_transform.basis.z * speed * delta
	
	if raycast.is_colliding():
		queue_free()
