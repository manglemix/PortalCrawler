@tool
extends EnemyState


signal tired_finished

const DURATION := 3.0

@onready var sprite: AnimatedSprite3D = $"../../Billboard/AnimatedSprite3D"


func _enter() -> void:
	super()
	stop_navigation()
	sprite.play("start_teleport")
	sprite.set_process(false)
	await sprite.animation_finished
	transform.origin = Vector3(lerpf(-5.5, 5.5, randf()), 0, lerpf(-2.6, 2.6, randf()))
	sprite.play("end_teleport")
	await sprite.animation_finished
	sprite.play("tired")
	await get_tree().create_timer(DURATION, false).timeout
	if is_active():
		sprite.set_process(true)
		exit(tired_finished)
