extends Node


const SAVE_FILE := "user://save.res"

var has_godot_plushie := false

var _difficulty := 0
var _ignore_saves := false

func _ready() -> void:
	_ignore_saves = FileAccess.file_exists(".ignore-saves")
	await get_tree().process_frame
	await get_tree().process_frame
	read_save_file()


func get_difficulty() -> int:
	return _difficulty


func change_difficulty(value: int) -> void:
	_difficulty += value


func read_save_file() -> void:
	# Disable save system
	return
	#var data := {}
	#if !_ignore_saves and FileAccess.file_exists(SAVE_FILE):
		#var packed: PackedDataContainer = load(SAVE_FILE)
		#for key in packed:
			#data[key] = packed[key]
	#for fragment: SaveDataFragment in get_children():
		#fragment._load_save_data(data)


func save_game() -> void:
	# Disable save system
	return
	#if _ignore_saves:
		#return
	#var data := {}
	#for fragment: SaveDataFragment in get_children():
		#fragment._create_save_data(data)
	#var packed = PackedDataContainer.new()
	#packed.pack(data)
	#ResourceSaver.save(packed, SAVE_FILE)


func _exit_tree() -> void:
	save_game()
