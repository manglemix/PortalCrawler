@tool
class_name Level
extends Node3D


const NEXT_LEVEL_DISTANCE := 40.0
const TRAVEL_DURATION := 1.0

signal level_complete

@export_file("*.tscn") var next_level: String:
	set(x):
		next_level = x
		update_configuration_warnings()

@export var player_spawn_point: Node3D:
	set(x):
		player_spawn_point = x
		update_configuration_warnings()

@export var is_empty := false

var _player: Player
var _camera: Camera3D

@onready var _level_music_player: AudioStreamPlayer3D = player_spawn_point.get_node("LevelMusicPlayer")


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	
	if next_level.is_empty():
		warnings.append("next_level must be provided")
	
	if player_spawn_point == null:
		warnings.append("player_spawn_point must be provided")
	
	return warnings


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if is_empty:
		await get_tree().process_frame
		while _player == null:
			await get_tree().process_frame
		_on_finished()

func set_player(player: Player) -> void:
	_player = player
	_player.global_position = get_player_spawnpoint()
	_player.reset_game.connect(_advance_level.bind("res://levels/special/intro/intro.tscn"))
	_player.advancing_level.connect(_advance_level.bind(next_level))
	_level_music_player.reparent(_player)
	
	if _player.is_teleporting:
		await _player.appeared
	
	for spawner: Spawner in get_tree().get_nodes_in_group("EnemySpawners"):
		if !is_ancestor_of(spawner):
			continue
		spawner.spawned.connect(
			func(enemy: Enemy):
				enemy.set_player(player)
		)
	
	for enemy: Enemy in get_tree().get_nodes_in_group("Enemies"):
		if !is_ancestor_of(enemy):
			continue
		enemy.set_player(player)


func get_player_spawnpoint() -> Vector3:
	return player_spawn_point.global_position


func set_camera(camera: Camera3D) -> void:
	_camera = camera


func _on_finished() -> void:
	level_complete.emit()
	# You were cheating weren't you
	_player._on_level_finished()


func _on_can_move_on() -> void:
	GameState.save_game()
	_player._on_can_move_on()


func _advance_level(to: String) -> void:
	var next_level_node: Level = load(to).instantiate()
	var travel := Vector3.ZERO
	while true:
		travel = Vector3(randf() * 2 - 1, 0, randf() * 2 - 1).normalized()
		if travel.is_normalized():
			break
	travel *= NEXT_LEVEL_DISTANCE
	next_level_node.position = position + travel
	get_parent().add_child(next_level_node)
	get_parent().move_child(next_level_node, 0)
	_camera		\
		.create_tween()		\
		.tween_property(
			_camera,
			"fov",
			5,
			0.3
		)		\
		.set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(0.15, false).timeout
	_level_music_player.reparent(self)
	var audio_listener: AudioListener3D = _player.get_node("AudioListener3D")
	audio_listener.reparent(get_viewport())
	audio_listener		\
		.create_tween()		\
		.tween_property(
			audio_listener,
			"position",
			next_level_node.get_player_spawnpoint(),
			TRAVEL_DURATION
		)		\
		.set_trans(Tween.TRANS_CUBIC)
	var slide_tween := _camera		\
		.create_tween()		\
		.tween_property(
			_camera,
			"position",
			Vector3(next_level_node.position.x, _camera.position.y, next_level_node.position.z),
			TRAVEL_DURATION
		)		\
		.set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(TRAVEL_DURATION - 0.3, false).timeout
	_camera		\
		.create_tween()		\
		.tween_property(
			_camera,
			"fov",
			3.8,
			0.3
		)		\
		.set_trans(Tween.TRANS_CUBIC)
	await slide_tween.finished
	queue_free()
	next_level_node.set_camera(_camera)
	next_level_node.set_player(_player)
	audio_listener.reparent(_player)
	_player._on_level_advanced()
