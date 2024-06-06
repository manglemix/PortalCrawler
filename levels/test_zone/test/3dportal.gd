extends StaticBody3D


var collider
var cZOffset
var cXOffset
var p

@onready var cooldown = $cooldown

var facing

# Called when the node enters the scene tree for the first time.
func _ready():
	collider = $Area3D
	cZOffset = self.get_global_position().z
	cXOffset = self.get_global_position().x
	
	facing = ''

func update_position():
	cZOffset = self.get_global_position().z
	cXOffset = self.get_global_position().x
	
func update_direction(direction):
	facing = direction
	
func _set_partner(partner):
	p = partner
	
func _physics_process(delta):
	var bodies = collider.get_overlapping_bodies()
	for body in bodies:
		if (!check_velocity(body.target_velocity)):
			return
		if(p == null):
			return
		var bodyY = body.get_global_position().y
		var bodyX = body.get_global_position().x
		var bodyZ = body.get_global_position().z
		body.set_global_position(Vector3(p.cXOffset, bodyY, p.cZOffset))
		
func check_velocity(velocity):
	print(velocity)
	if (facing == 'l'):
		return velocity.x < 0
	if (facing == 'r'):
		return velocity.x > 0
	if (facing == 'u'):
		return velocity.z < 0
	if (facing == 'd'):
		return velocity.z > 0

