class_name CardinalAnimationState
extends AnimationState

enum Direction { LEFT, RIGHT, UP, DOWN }

@export var up := &"up"
@export var down := &"down"
@export var left := &"right"
@export var right := &"right"
@export var always_update := false
@export var rotation_source: Node3D

var _just_entered := false


func _ready() -> void:
	super()
	animation_finished.connect(exit)


func _enter() -> void:
	_just_entered = true
	if always_update:
		set_process(true)
	else:
		_process(0)


func _process(_delta: float) -> void:
	var new_anim := &""
	match get_direction():
		Direction.RIGHT:
			new_anim = right
			flip_h = false
		Direction.DOWN:
			new_anim = down
			flip_h = false
		Direction.UP:
			new_anim = up
			flip_h = false
		Direction.LEFT:
			new_anim = left
			flip_h = left == right
	if _just_entered or new_anim != animation:
		play(new_anim)
	_just_entered = false


func get_direction() -> Direction:
	var forward_3d: Vector3 = -rotation_source.global_basis.z
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
