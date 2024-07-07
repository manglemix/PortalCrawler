class_name Collectible
extends RigidBody3D


signal contacted_player
signal clearing_display

@export var speed := 6.0
@export var display_rotation := Vector3.ZERO
@export var display_origin := Vector3(0.0, 87.0, 0.0)
@export var to_display: Node3D


func _ready() -> void:
	max_contacts_reported = 4
	contact_monitor = true
	collision_layer = 0
	collision_mask = 3
	can_sleep = false
	set_process_input(false)
	await get_tree().process_frame
	linear_velocity = global_basis.z * - speed
	
	while true:
		var body: Node = await body_entered
		if body is Player:
			contacted_player.emit()
			if !is_instance_valid(to_display):
				break
			Collectibles.move_to_collectible_viewport(to_display)
			var display_quat := Quaternion.from_euler(Vector3(deg_to_rad(display_rotation.x), deg_to_rad(display_rotation.y), deg_to_rad(display_rotation.z)))
			
			to_display.create_tween().tween_property(to_display, "quaternion", display_quat, 1.0).set_trans(Tween.TRANS_EXPO)
			to_display.create_tween().tween_property(to_display, "position", display_origin, 1.0).set_trans(Tween.TRANS_EXPO)
			freeze = true
			collision_mask = 0
			await get_tree().create_timer(1.5, false).timeout
			set_process_input(true)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.pressed:
			return
	elif event is InputEventKey:
		if !event.pressed:
			return
	elif event is InputEventJoypadButton:
		if !event.pressed:
			return
	else:
		return
	
	set_process_input(false)
	clearing_display.emit()
	Collectibles.clear_display()
	await to_display.create_tween().tween_property(to_display, "scale", Vector3.ZERO, 1.0).set_trans(Tween.TRANS_EXPO).finished
	to_display.queue_free()
	queue_free()