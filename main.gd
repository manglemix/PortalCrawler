extends Node3D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.pressed:
			return
	elif event is InputEventKey:
		if !event.pressed:
			return
	elif event is InputEventJoypadButton:
		if !event.pressed:
			return
	else:
		return
	
	var camera: Camera3D = $Camera3D
	set_process_input(false)
	await create_tween().tween_property(camera, "position:z", 0, 3.5).set_trans(Tween.TRANS_QUAD).finished
	var title: AnimatedSprite3D = $Title
	title.queue_free()
	var intro_level: Level = $Intro
	var player: Player = preload("res://player/player.tscn").instantiate()
	player.add_child(AudioListener3D.new(), true)
	player.position = intro_level.get_player_spawnpoint()
	add_child(player)
	var hud := preload("res://player/hud.tscn").instantiate()
	hud.player = player
	await player.appeared
	intro_level.set_player(player)
	intro_level.set_camera(camera)
	$CanvasLayer.add_child(hud)
