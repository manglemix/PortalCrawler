extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 5

@onready var first = true

@onready var counter = 0

var target_velocity = Vector3.ZERO

func _physics_process(_delta):
	if (first):
		get_parent().get_node("leftPortal")._set_partner(get_parent().get_node("rightPortal"))
		get_parent().get_node("rightPortal")._set_partner(get_parent().get_node("leftPortal"))
		first = false
	
	if (counter > 100):
		print(self.get_global_position())
		counter = 0
	counter += 1
	
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
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
	move_and_slide()
