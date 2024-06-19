extends StaticBody3D

# some nodes for easy access later
@onready var collider = $PortalArea
@onready var cooldown = $cooldown

@onready var leftray = $LeftChecker
@onready var rightray = $RightChecker

# holds the portals partner for easy reference
var p
var facing

@onready var deletable = false

func _ready():
	name = "portal"
# obviously could grab these values without storing them, but for
# code readability and performance we store them after they are updated 1 time
var cZOffset
var cXOffset

# these 2 functions are called 1 time by the player when the portal is being setup
# they handle the portals position and rotation
func update_position():
	cZOffset = self.get_global_position().z
	cXOffset = self.get_global_position().x
	leftray.force_raycast_update()
	rightray.force_raycast_update()
	if (!leftray.is_colliding() || !rightray.is_colliding()):
		return false
	else:
		return true
func update_direction(direction):
	facing = direction

# gives this portal a reference to its partner portal, updated by the creation of
# new portals
func _set_partner(partner):
	p = partner

func _physics_process(_delta):
	# if there is no partner then no work is needed, return
	if(p == null):
			return
	# check all overlapping bodies to see if they need to be teleported
	var bodies = collider.get_overlapping_bodies()
	for body in bodies:
		# SPECIFICALLY target_velocity must exist for objects to be teleported, normal velocity
		# values do not work because the real velocity value will often drop to 0 when the object hits
		# the wall the portal is on before being checked for teleportation
		if (!check_velocity(body.target_velocity)):
			return
		# get the objects y value because that does not change, then teleport it
		var bodyY = body.get_global_position().y
		body.set_global_position(Vector3(p.cXOffset, bodyY, p.cZOffset))
		
# small helper function that checks if the object hitting
# a portals collider is moving with any velocity into the portal
func check_velocity(velocity):
	if (facing == 'l'):
		return velocity.x < 0
	if (facing == 'r'):
		return velocity.x > 0
	if (facing == 'u'):
		return velocity.z < 0
	if (facing == 'd'):
		return velocity.z > 0





func _on_mouse_area_mouse_entered():
	print("detected")
	deletable = true


func _on_mouse_area_mouse_exited():
	print("left")
	deletable = false
