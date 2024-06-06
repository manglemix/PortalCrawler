@tool
class_name Damageable
extends Node


signal damaged(health_change: int)

@export var damage_multiplier := 1.0

func _get_configuration_warnings() -> PackedStringArray:
	if name != "Damageable":
		return ["Name must be Damageable"]
	return []


func _ready() -> void:
	if Engine.is_editor_hint():
		renamed.connect(update_configuration_warnings)


func damage_once(damage: int):
	damaged.emit(roundi(damage * damage_multiplier))


static func get_damageable_component(node: Node) -> Damageable:
	return node.get_node_or_null("Damageable")


static func damage_node_once(node: Node, damage: int):
	var damageable := get_damageable_component(node)
	if damageable == null:
		return
	damageable.damage_once(damage)
