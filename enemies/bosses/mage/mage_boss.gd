@tool
class_name MageBoss
extends Enemy


const MIN_DISTANCE := 2.0
const SPEED := 1.0


func _ready() -> void:
	super()
	$Health.died.connect(GameState.change_difficulty.bind(1))
