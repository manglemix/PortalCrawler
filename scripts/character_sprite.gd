@tool
class_name CharacterSprite
extends AnimatedSprite3D

enum Direction { LEFT, RIGHT, UP, DOWN }

@export var death = &"death"

@export_group("Idle Animations")
@export var idle_down := &"idle_down"
@export var idle_right := &"idle_right"
@export var idle_up := &"idle_up"

@export_group("Walk Animations")
@export var walk_down := &"walk_down"
@export var walk_right := &"walk_right"
@export var walk_up := &"walk_up"

@export_group("Attack Animations")
@export var attack_down := &"swing_down"
@export var attack_right := &"swing_right"
@export var attack_up := &"swing_up"

var _dying := false


func _get_configuration_warnings() -> PackedStringArray:
	if not get_parent() is CharacterBody3D:
		return ["Parent must be a CharacterBody3D"]
	return []


func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)


func _process(_delta: float) -> void:
	var new_anim: StringName
	var linear_velocity: Vector3 = get_parent().velocity
	
	if linear_velocity.length() <= 0.05:
		match get_direction():
			Direction.RIGHT:
				new_anim = idle_right
				flip_h = false
			Direction.DOWN:
				new_anim = idle_down
				flip_h = false
			Direction.UP:
				new_anim = idle_up
				flip_h = false
			Direction.LEFT:
				new_anim = idle_right
				flip_h = true
			
	else:
		match get_direction():
			Direction.RIGHT:
				new_anim = walk_right
				flip_h = false
			Direction.DOWN:
				new_anim = walk_down
				flip_h = false
			Direction.UP:
				new_anim = walk_up
				flip_h = false
			Direction.LEFT:
				new_anim = walk_right
				flip_h = true
	
	if animation != new_anim:
		play(new_anim)


func get_direction() -> Direction:
	var forward_3d: Vector3 = -global_basis.z
	var forward := Vector2(forward_3d.x, forward_3d.z).normalized()
	var angle := forward.angle()
	if - PI / 4 < angle and angle < PI / 4:
		return Direction.RIGHT
	elif PI / 4 < angle and angle < 3 * PI / 4:
		return Direction.DOWN
	elif - 3 * PI / 4 < angle and angle < - PI / 4:
		return Direction.UP
	else:
		return Direction.LEFT


func attack() -> void:
	if _dying:
		return
	set_process(false)
	animation_finished.connect(
		func():
			set_process(!_dying)
	, CONNECT_ONE_SHOT)
	
	match get_direction():
		Direction.RIGHT:
			play(attack_right)
			flip_h = false
		Direction.DOWN:
			play(attack_down)
			flip_h = false
		Direction.UP:
			play(attack_up)
			flip_h = false
		Direction.LEFT:
			play(attack_right)
			flip_h = true


func die() -> void:
	_dying = true
	set_process(false)
	play(death)
