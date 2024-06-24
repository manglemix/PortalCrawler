@tool
class_name PermaWander
extends EnemyState


@export var wander_speed := 0.75


@warning_ignore("shadowed_variable")
func set_player(player: Player) -> void:
	super(player)
	var health := Health.get_health_component(player)
	health.died.connect(pull_state)


func _enter() -> void:
	super()
	if wander_speed > 0:
		set_physics_process(true)
		set_navigation_target(Wander.random_target(global_transform.origin))


func _physics_process(_delta: float) -> void:
	if navigation.is_navigation_finished():
		set_navigation_target(Wander.random_target(global_transform.origin))
	navigate_to_next_path_position(wander_speed)
