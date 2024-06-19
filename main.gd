extends Node3D


@onready var player: Player = $Player


func _ready() -> void:
	var health := Health.get_health_component(player)
	health.died.connect(
		func():
			await get_tree().create_timer(3.0, false).timeout
			get_tree().change_scene_to_file("res://main.tscn")
	)
