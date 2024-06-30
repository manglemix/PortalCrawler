class_name StagedSpawner
extends Spawner


const SPAWN_GROUP := &"Enemies"

signal stage_finished
signal finished

@export var scenes: Array[PackedScene] = []
@export var spawn_stage_delay := 1.0

var index := 0
var _finished := false


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
		on_spawned_free()
		return
	
	var node: Enemy = scene.instantiate()
	node.died.connect(on_spawned_free)
	node.tree_entered.connect(
		func():
			spawned.emit(node)
	)
	add_child(node)


func on_spawned_free() -> void:
	#if !is_inside_tree():
		#return
	
	var alive := false
	
	for node: Enemy in get_tree().get_nodes_in_group(SPAWN_GROUP):
		var health := Health.get_health_component(node)
		if health != null and health.health == 0:
			continue
		if !node.died.is_connected(on_spawned_free):
			node.died.connect(on_spawned_free)
		alive = true
	
	if !alive:
		stage_finished.emit()
		spawn()
