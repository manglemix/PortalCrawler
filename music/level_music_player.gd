extends AudioStreamPlayer3D


func _ready():
	play(wrapf(LevelMusic.get_play_time(), 0, stream.get_length()))
