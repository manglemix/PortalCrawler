@tool
extends EnemyState


signal attack_finished
signal start_lasers
signal spawn_clones

const DURATION := 4.0
const CLONE_COUNT := 2

var clone_count := 0

@onready var sprite: AnimatedSprite3D = $"../../Billboard/AnimatedSprite3D"


func _enter() -> void:
	super()
	stop_navigation()
	if clone_count < CLONE_COUNT:
		if randf() <= 0.5:
			look_at(player.global_position)
			sprite.set_process(false)
			sprite.swing()
			await get_tree().create_timer(0.2, false).timeout
			spawn_clones.emit()
			clone_count += CLONE_COUNT
			
			for _i in range(CLONE_COUNT):
				var mage: Enemy = preload("res://enemies/bosses/mage/mage_clone.tscn").instantiate()
				mage.set_player(player)
				mage.transform.origin = Vector3(lerpf(-5.5, 5.5, randf()), 0, lerpf(-2.6, 2.6, randf())) + get_parent_origin()
				var mage_health := Health.get_health_component(mage)
				
				get_health().died.connect(
					func():
						if is_instance_valid(mage_health):
							mage_health.health = 0
				)
				mage_health.died.connect(
					func():
						clone_count -= 1
				)
				
				add_child(mage)
			
			await sprite.animation_finished
			sprite.set_process(true)
			get_tree().create_timer(0.5, false).timeout.connect(exit.bind(attack_finished))
			return
	
	sprite.start_shooting()
	start_lasers.emit()
	set_physics_process(true)
	get_tree().create_timer(DURATION, false).timeout.connect(exit.bind(attack_finished))


func _exit() -> void:
	sprite.start_walking()


func _physics_process(_delta: float) -> void:
	look_at(player.global_position)
