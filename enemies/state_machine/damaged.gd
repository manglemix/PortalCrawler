@tool
extends EnemyState


const KNOCKBACK_DURATION := 0.2

signal stun_finished

@export var delay := 0.6
@export var knockback_speed := 6.0

var _timer := 0.0
var _tween: Tween


func _ready() -> void:
	super()
	hide_errors()


func _on_damaged(_damage: int, from: Node = null) -> void:
	if is_active():
		_timer += delay
		_knockback(from)
	else:
		if pull_state():
			_knockback(from)


func _enter() -> void:
	_timer = delay
	set_process(true)


func _process(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0:
		exit(stun_finished)


func _knockback(from: Node) -> void:
	if from == null:
		return
	if "global_position" in from:
		var from_position: Vector3 = from.global_position
		var travel := (global_transform.origin - from_position).normalized()
		if travel.is_normalized():
			linear_velocity = travel * knockback_speed
			if _tween != null:
				_tween.stop()
			_tween = create_tween()
			_tween.tween_property(self, "linear_velocity", Vector3.ZERO, minf(KNOCKBACK_DURATION, delay))
