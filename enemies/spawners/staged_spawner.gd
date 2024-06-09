@tool
class_name StagedSpawner
extends Spawner


signal stage_finished
signal finished

@export var spawn_group := &"Enemies"
@export var scenes: Array[PackedScene] = []
@export var spawn_stage_delay := 1.0

var index := 0
var _finished := false


func _get_configuration_warnings() -> PackedStringArray:
	if spawn_group == &"Enemies" && !get_groups().has("EnemySpawners"):
		return ["If spawn_group is Enemies, spawner must be in EnemySpawners group"]
	return []


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	spawn()


func spawn() -> void:
	if index >= scenes.size():
		if !_finished:
			_finished = true
			finished.emit()
		return
	if index > 0:
		await get_tree().create_timer(spawn_stage_delay, false).timeout
	var scene := scenes[index]
	index += 1
	
	if scene == null:
		await get_tree().process_frame
		@warning_ignore("confusable_local_declaration")
		var node := get_tree().get_first_node_in_group(spawn_group)
		if node == null:
			stage_finished.emit()
			spawn()
		else:
			node.tree_exited.connect(on_spawned_free)
		return
	
	var node := scene.instantiate()
	node.tree_exited.connect(on_spawned_free)
	node.tree_entered.connect(
		func():
			spawned.emit(node)
	)
	add_child(node)


func on_spawned_free() -> void:
	if !is_inside_tree():
		return
	var node := get_tree().get_first_node_in_group(spawn_group)
	if node == null:
		stage_finished.emit()
		spawn()
	else:
		node.tree_exited.connect(on_spawned_free)
