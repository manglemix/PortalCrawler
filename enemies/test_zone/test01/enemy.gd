class_name Enemy
extends CharacterBody3D


@export var navigation: NavigationAgent3D
@export var state_machine: EnemyStateMachine


func _ready() -> void:
	if navigation != null:
		await get_tree().physics_frame
		await get_tree().physics_frame
	if state_machine != null:
		for state in state_machine.get_enemy_states():
			state.velocity_computed.connect(set_velocity)
			state.set_enemy(self)
			state.set_navigation(navigation)
		if !state_machine.enter_on_ready:
			state_machine.enter()


func _physics_process(_delta: float) -> void:
	move_and_slide()
