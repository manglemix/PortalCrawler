@tool
class_name Health
extends Node


signal died


@export var health := 10:
	set = set_health

@export var max_health := 10:
	set = set_max_health


func _get_configuration_warnings() -> PackedStringArray:
	if name != "Health":
		return ["Name must be Health"]
	return []


func _ready() -> void:
	if Engine.is_editor_hint():
		renamed.connect(update_configuration_warnings)


func set_health(new_health: int):
	health = clampi(new_health, 0, max_health)
	if health == 0:
		died.emit()


func set_max_health(new_max_health: int):
	if new_max_health < 0:
		max_health = 0
	else:
		max_health = new_max_health
	
	if max_health < health:
		health = max_health


func change_health(change: int):
	health += change


static func get_health_component(node: Node) -> Health:
	if node == null:
		return null
	return node.get_node_or_null("Health")


static func set_node_health(node: Node, new_health: int):
	var health_node := get_health_component(node)
	if health_node == null:
		return
	health_node.set_health(new_health)


static func change_node_health(node: Node, change: int):
	var health_node := get_health_component(node)
	if health_node == null:
		return
	health_node.change_health(change)
