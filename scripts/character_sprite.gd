class_name CharacterSprite
extends AnimatedSprite3D

signal death_animation_finished

enum Direction { LEFT, RIGHT, UP, DOWN }

@export var damage_flash_duration := 0.2
@export var character: CharacterBody3D
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
@export var attack_down := &"attack_down"
@export var attack_right := &"attack_right"
@export var attack_up := &"attack_up"

var _dying := false


func _process(_delta: float) -> void:
	var new_anim: StringName
	var linear_velocity: Vector3 = character.velocity
	
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
	var forward_3d: Vector3 = -character.global_basis.z
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


func cancel_attack() -> void:
	set_process(!_dying)


func die() -> void:
	if !visible:
		return
	_dying = true
	set_process(false)
	play(death)
	await animation_finished
	death_animation_finished.emit()


func reset() -> void:
	_dying = false
	set_process(true)


func damage_flash(_damage:=0):
	if _dying:
		return
	modulate = Color.RED
	create_tween().tween_property(self, "modulate", Color.WHITE, damage_flash_duration)
