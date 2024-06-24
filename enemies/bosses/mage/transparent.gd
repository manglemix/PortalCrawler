@tool
extends EnemyState


signal transparency_finished

const DURATION := 5.0
const SPEED := 5.0
const TWEEN_DURATION := 0.3
const TRANSPARENCY := 0.01

@onready var sprite: AnimatedSprite3D = $"../../Billboard/AnimatedSprite3D"
@onready var shadow: MeshInstance3D = $"../../MeshInstance3D"


func _enter() -> void:
	super()
	set_physics_process(true)
	set_navigation_target(Wander.random_target(global_transform.origin))
	get_tree().create_timer(DURATION, false).timeout.connect(exit.bind(transparency_finished))
	shadow.hide()
	sprite.create_tween().tween_property(sprite, "modulate:a", TRANSPARENCY, TWEEN_DURATION)


func _exit() -> void:
	super()
	shadow.show()
	sprite.create_tween().tween_property(sprite, "modulate:a", 1, TWEEN_DURATION)


func _physics_process(_delta: float) -> void:
	if navigation.is_navigation_finished():
		set_navigation_target(Wander.random_target(global_transform.origin))
	navigate_to_next_path_position(SPEED)
