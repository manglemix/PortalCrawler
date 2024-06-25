@tool
extends EnemyState


signal attack_finished
signal attacked

const DURATION := 4.0

#@onready var areas: Node3D = $Node3D
#@onready var area1: Area3D = $Node3D/Area3D1
#@onready var area2: Area3D = $Node3D/Area3D2
#@onready var area3: Area3D = $Node3D/Area3D3
#@onready var area4: Area3D = $Node3D/Area3D4
@onready var sprite: AnimatedSprite3D = $"../../Billboard/AnimatedSprite3D"


func _enter() -> void:
	super()
	stop_navigation()
	sprite.set_process(false)
	
	var count := randi_range(2, 4)
	for _i in range(count):
		sprite.play("start_teleport")
		sprite.set_process(false)
		await sprite.animation_finished
		transform.origin = Vector3(lerpf(-5.5, 5.5, randf()), 0, lerpf(-2.6, 2.6, randf()))
		sprite.play("end_teleport")
		await sprite.animation_finished
		
		look_at(player.global_position)
		await get_tree().create_timer(0.1, false).timeout
		sprite.swing()
		attacked.emit()
		await sprite.animation_finished
	
	sprite.set_process(true)
	exit(attack_finished)
