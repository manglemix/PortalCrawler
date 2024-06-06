extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 5

@onready var first = true

@onready var ray = $RayCast3D

@onready var left = true

var target_velocity = Vector3.ZERO

func get_input():
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	if Input.is_action_just_pressed("shoot"):
		var rayvector = Vector3.ZERO
		if (ray.is_colliding()):
			rayvector = ray.get_collision_normal()
			if (rayvector.x > .7):
				print("left")
			elif (rayvector.x < -.7):
				print("right")
			elif (rayvector.z > .7):
				print("up")
			elif (rayvector.z < -.7):
				print("down")
			print(rayvector)
		else:
			print("no collision")
	
		
			
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("right"):
		direction.x += 1
		if (!left):
			ray.rotate_y(PI)
			left = true
	if Input.is_action_pressed("left"):
		direction.x -= 1
		if (left):
			left = false
			ray.rotate_y(PI)
	if Input.is_action_pressed("down"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1
	if Input.is_action_pressed("up"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Moving the Character
	velocity = target_velocity

func _physics_process(_delta):
	if (first):
		get_parent().get_node("leftPortal")._set_partner(get_parent().get_node("rightPortal"))
		get_parent().get_node("rightPortal")._set_partner(get_parent().get_node("leftPortal"))
		first = false
	
	
	get_input()
	move_and_slide()
