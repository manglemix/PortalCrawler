@tool
class_name Enemy
extends CharacterBody3D


@export var navigation: NavigationAgent3D
@export var state_machine: EnemyStateMachine


func _get_configuration_warnings() -> PackedStringArray:
	if !get_groups().has("Enemies"):
		return ["Must be in Enemies group"]
	return []


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if navigation != null:
		await get_tree().physics_frame
		await get_tree().physics_frame
	if state_machine != null:
		state_machine.set_enemy(self)
		if navigation != null:
			state_machine.set_navigation(navigation)
		if !state_machine.enter_on_ready:
			state_machine.enter()


func _physics_process(_delta: float) -> void:
	move_and_slide()


func set_player(player: CharacterBody3D) -> void:
	if state_machine != null:
		state_machine.set_player(player)
