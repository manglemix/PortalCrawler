@tool
class_name MageBoss
extends Enemy


signal died


const MIN_DISTANCE := 2.0
const SPEED := 1.0


func _ready() -> void:
	super()
	var health := Health.get_health_component(self)
	health.died.connect(func(): died.emit())
