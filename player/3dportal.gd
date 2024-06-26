class_name Portal
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

	# check all overlapping bodies to see if they need to be teleported
	var bodies = collider.get_overlapping_bodies()
	for body in bodies:
		# if there is no partner then no work is needed, return
		if(p == null):
			if (body.name.begins_with("Basic")):
				body.queue_free()
			return
		if (body.name == "Player"):
			if (!check_velocity(body.target_velocity)):
				return
		else:
			if (!check_rotation(body.rotation)):
				return
		# get the objects y value because that does not change, then teleport it
		var bodyY = body.get_global_position().y
		body.set_global_position(Vector3(p.cXOffset, bodyY, p.cZOffset))
		body.get_node("Teleportable")._teleported(self, p)
		
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
		
func check_rotation(g_rotation):
	if (facing == 'l'):
		return g_rotation.y > 0 && g_rotation.y < PI
	if (facing == 'r'):
		return g_rotation.y < 0 && g_rotation.y > -PI
	if (facing == 'u'):
		return g_rotation.y > -PI/2 && g_rotation.y < PI/2
	if (facing == 'd'):
		return g_rotation.y > PI/2 || g_rotation.y < -PI/2


func _on_mouse_area_mouse_entered():
	deletable = true
func _on_mouse_area_mouse_exited():
	deletable = false


func _exit_tree() -> void:
	if (deletable == false):
		return
	var out := preload("res://player/portal/portal_out.tscn").instantiate()
	out.get_node("Sprite3D").modulate = $Sprite3D.modulate
	out.get_node("Sprite3D/AnimatedSprite3D").modulate = $Sprite3D.modulate
	out.transform = transform
	get_parent().add_child.call_deferred(out)
