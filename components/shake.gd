@tool
class_name Shake
extends Node


signal translate_3d(translation: Vector3)
signal translate_2d(translation: Vector2)
signal finished

@export var use_accessibility := false

@export var x_scale := 1.0
@export var y_scale := 1.0
@export var z_scale := 1.0

var path: Array[Vector3] = []
var origin := Vector3.ZERO
var speed: float


func _get_configuration_warnings() -> PackedStringArray:
	if name != "Shake":
		return ["Name must be Shake"]
	return []


func _ready() -> void:
	if Engine.is_editor_hint():
		renamed.connect(update_configuration_warnings)
	set_process(false)


func is_shaking() -> bool:
	return !path.is_empty()


func shake(duration: float, amplitude: float, points: int) -> void:
	if is_shaking():
		return
	if use_accessibility:
		amplitude *= ProjectSettings.get_setting("accessibility/camera_shake")
	set_process(true)
	var length := 0.0
	for i in range(points):
		var vector: Vector3
		if i + 1 == points:
			vector = Vector3.ZERO
		else:
			vector = Vector3(
				(2 * randf() - 1) * x_scale * amplitude,
				(2 * randf() - 1) * y_scale * amplitude,
				(2 * randf() - 1) * z_scale * amplitude
			)
			vector /= Vector3(x_scale, y_scale, z_scale).length()
		
		path.append(vector)
		
		var last_point: Vector3
		if i == 0:
			last_point = origin
		else:
			last_point = path[i - 1]
		length += last_point.distance_to(vector)
		speed = length / duration


static func get_shake_component(node: Node) -> Shake:
	if node == null:
		return null
	return node.get_node_or_null("Shake")


static func shake_node(node: Node, duration: float, amplitude: float, points: int) -> void:
	@warning_ignore("shadowed_variable")
	var shake_node := get_shake_component(node)
	if shake_node == null:
		return
	shake_node.shake(duration, amplitude, points)


func _process(delta: float) -> void:
	var travel: Vector3 = path.front() - origin
	var distance := travel.length()
	var translation := Vector3.ZERO
	var step := speed * delta
	if distance <= step:
		translation = path.front() - origin
		origin = path.front()
		path.pop_front()
		if path.is_empty():
			finished.emit()
			set_process(false)
	else:
		translation = travel / distance * step
		origin += translation
	translate_3d.emit(translation)
	translate_2d.emit(Vector2(translation.x, translation.y))
