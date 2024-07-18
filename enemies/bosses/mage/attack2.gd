@tool
extends EnemyState


signal teleporting
signal teleported
signal attack_finished
signal attacked

const DURATION := 4.0

@onready var sprite: AnimatedSprite3D = $"../../Billboard/AnimatedSprite3D"


func _enter() -> void:
	super()
	stop_navigation()
	sprite.set_process(false)
	
	var count := randi_range(2, 4)
	for _i in range(count):
		teleporting.emit()
		sprite.play("start_teleport")
		sprite.set_process(false)
		await sprite.animation_finished
		if !is_active():
			return
		transform.origin = Vector3(lerpf(-5.5, 5.5, randf()), 0, lerpf(-2.6, 2.6, randf()))
		sprite.play("end_teleport")
		await sprite.animation_finished
		teleported.emit()
		if !is_active():
			return
		
		look_at(player.global_position)
		await get_tree().create_timer(0.1, false).timeout
		if !is_active():
			return
		sprite.swing()
		attacked.emit()
		await sprite.animation_finished
		if !is_active():
			return
	
	sprite.set_process(true)
	exit(attack_finished)
