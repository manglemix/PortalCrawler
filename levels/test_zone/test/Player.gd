extends CharacterBody3D

# exported vars
@export var speed = 5

# stored nodes/scenes for easy reference
@onready var ray = $RayCast3D
var portal = preload("res://object_scenes/portal.tscn")

# these are some simple flags for the portal placement code
@onready var firstplaced = false
@onready var secondplaced = false

# general vars
var firstPortal
var secondPortal
var target_velocity = Vector3.ZERO

# hotfix for making sure the node is named properly, remove later
func _ready():
	name = "Player"

# all input from the player is handled here
func _input(event):
	var direction = Vector3.ZERO
	
	# shooting portals
	if Input.is_action_just_pressed("shoot"):
		_create_portal()
	
	# movement
	if Input.is_action_pressed("right"):
		direction.x += 1
		ray.set_rotation_degrees(Vector3(0, 0, 0))
		rotation.y = - PI / 2
	if Input.is_action_pressed("left"):
		direction.x -= 1
		ray.set_rotation_degrees(Vector3(0, 180, 0))
		rotation.y = PI / 2
	if Input.is_action_pressed("down"):
		ray.set_rotation_degrees(Vector3(0, -90, 0))
		direction.z += 1
		rotation.y = PI
	if Input.is_action_pressed("up"):
		ray.set_rotation_degrees(Vector3(0, 90, 0))
		direction.z -= 1
		rotation.y = 0.0
		
	# applying movement
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	velocity = target_velocity

func _physics_process(_delta):
	move_and_slide()


func _on_damaged(_health_change: int) -> void:
	Shake.shake_node(get_viewport().get_camera_3d(), 0.25, 0.2, 5)
	
	
# function that creates the portals when the player presses the button to do so
# the reason why the player is handling this code is because all player inputs
# should be handled by the player script when possible
func _create_portal():
	if (ray.is_colliding()):
		# this block handles the constant cycling of portals as you spawn more and more
		var newportal = portal.instantiate()
		if (!firstplaced):
			firstPortal = newportal
			firstplaced = true
		elif (!secondplaced):
			secondPortal = newportal
			secondplaced = true
			secondPortal._set_partner(firstPortal)
			firstPortal._set_partner(secondPortal)
		else:
			firstPortal.queue_free()
			firstPortal = secondPortal
			secondPortal = newportal
			secondPortal._set_partner(firstPortal)
			firstPortal._set_partner(secondPortal)
		
		# get the position to spawn the portal at
		var rayvector = Vector3.ZERO
		rayvector = ray.get_collision_normal()
		var xposition = ray.get_collision_point()
		
		# place the new portal at the correct position
		get_tree().root.get_child(0).add_child(newportal)
		newportal.set_global_position(xposition)
		
		# rotate the portal correctly and make sure it knows what way it's facing (for later use)
		if (rayvector.x > .7):
			newportal.update_direction('l')
		elif (rayvector.x < -.7):
			newportal.set_rotation_degrees(Vector3(0, 180, 0))
			newportal.update_direction('r')
		elif (rayvector.z > .7):
			newportal.set_rotation_degrees(Vector3(0, -90, 0))
			newportal.set_global_position(Vector3(xposition.x, xposition.y, xposition.z))
			newportal.update_direction('u')
		elif (rayvector.z < -.7):
			newportal.set_rotation_degrees(Vector3(0, 90, 0))
			newportal.set_global_position(Vector3(xposition.x, xposition.y, xposition.z))
			newportal.update_direction('d')
		# make sure the portal updates its stored position
		newportal.update_position()
