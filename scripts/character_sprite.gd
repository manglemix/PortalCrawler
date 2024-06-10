@tool
class_name CharacterSprite
extends AnimatedSprite3D


@export_group("Idle Animations")
@export var idle_down := &"idle_down"
@export var idle_right := &"idle_right"
@export var idle_up := &"idle_up"

@export_group("Walk Animations")
@export var walk_down := &"walk_down"
@export var walk_right := &"walk_right"
@export var walk_up := &"walk_up"


func _get_configuration_warnings() -> PackedStringArray:
	if not get_parent() is CharacterBody3D:
		return ["Parent must be a CharacterBody3D"]
	return []


func _process(_delta: float) -> void:
	var new_anim: StringName
	
	var linear_velocity: Vector3 = get_parent().velocity
	var parent_forward: Vector3 = -get_parent_node_3d().global_basis.z
	var forward := Vector2(parent_forward.x, parent_forward.z).normalized()
	var angle := forward.angle()
	#print(angle)
	
	if linear_velocity.length() <= 0.05:
		if - PI / 4 < angle and angle < PI / 4:
			new_anim = idle_right
			flip_h = false
		elif PI / 4 < angle and angle < 3 * PI / 4:
			new_anim = idle_down
			flip_h = false
		elif - 3 * PI / 4 < angle and angle < - PI / 4:
			new_anim = idle_up
			flip_h = false
		else:
			new_anim = idle_right
			flip_h = true
			
	else:
		if - PI / 4 < angle and angle < PI / 4:
			new_anim = walk_right
			flip_h = false
		elif PI / 4 < angle and angle < 3 * PI / 4:
			new_anim = walk_down
			flip_h = false
		elif - 3 * PI / 4 < angle and angle < - PI / 4:
			new_anim = walk_up
			flip_h = false
		else:
			new_anim = walk_right
			flip_h = true
	
	if animation != new_anim:
		play(new_anim)
