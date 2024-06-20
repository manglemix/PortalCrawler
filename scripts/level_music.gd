extends Node


#var current_audio_player: LevelMusicPlayer

var _play_time := 0.0

#
#func transition_to(next_level: Level) -> void:
	#var player: Player = current_audio_player.get_parent()
	#current_audio_player.reparent(player.get_parent())
	#current_audio_player = LevelMusicPlayer.new()
	#current_audio_player.stream = next_level.music
	#current_audio_player.position = next_level.get_player_spawnpoint()
	#add_child(current_audio_player)
	#current_audio_player.play(_play_time)
	#await get_tree().create_timer(Level.TRAVEL_DURATION, false).timeout
	#current_audio_player.reparent(player, false)


func _process(delta):
	_play_time += delta


func get_play_time() -> float:
	return _play_time
