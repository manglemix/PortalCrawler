@tool
class_name Damageable
extends Node


signal damaged(health_change: int)
signal damaged_from(health_change: int, from: Node)
signal damaged_opaque

@export var damage_multiplier := 1.0
@export var invincible := false:
	set = set_invincible

func set_invincible(value: bool) -> void:
	invincible = value


func _get_configuration_warnings() -> PackedStringArray:
	if name != "Damageable":
		return ["Name must be Damageable"]
	return []


func _ready() -> void:
	if Engine.is_editor_hint():
		renamed.connect(update_configuration_warnings)


func damage_once(damage: int, from: Node):
	if invincible:
		return
	damage = roundi(- damage * damage_multiplier)
	damaged_from.emit(damage, from)
	damaged.emit(damage)
	damaged_opaque.emit()


static func get_damageable_component(node: Node) -> Damageable:
	if node == null:
		return null
	return node.get_node_or_null("Damageable")


static func damage_node_once(node: Node, damage: int, from: Node):
	var damageable := get_damageable_component(node)
	if damageable == null:
		return
	damageable.damage_once(damage, from)
