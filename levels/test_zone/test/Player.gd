extends CharacterBody3D


# How fast the player moves in meters per second.
@export var speed = 5

@onready var first = true



@onready var ray = $RayCast3D

var portal = preload("res://portal.tscn")

var firstPortal
var secondPortal

@onready var firstplaced = false
@onready var secondplaced = false


var target_velocity = Vector3.ZERO

func _ready():
	name = "Player"

func get_input():
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	if Input.is_action_just_pressed("shoot"):
		var rayvector = Vector3.ZERO
		if (ray.is_colliding()):
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
			
			rayvector = ray.get_collision_normal()
			var xposition = ray.get_collision_point()
			
			get_tree().root.get_child(0).add_child(newportal)
			
			newportal.set_global_position(xposition)
			
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
				
			newportal.update_position()
			print(rayvector)
		else:
			print("no collision")
	
		
			
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("right"):
		direction.x += 1
		ray.set_rotation_degrees(Vector3(0, 0, 0))
	if Input.is_action_pressed("left"):
		direction.x -= 1
		ray.set_rotation_degrees(Vector3(0, 180, 0))
	if Input.is_action_pressed("down"):
		ray.set_rotation_degrees(Vector3(0, -90, 0))
		direction.z += 1
	if Input.is_action_pressed("up"):
		ray.set_rotation_degrees(Vector3(0, 90, 0))
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Moving the Character
	velocity = target_velocity

func _physics_process(_delta):
	get_input()
	move_and_slide()
	


func _on_damaged(_health_change: int) -> void:
	Shake.shake_node(get_viewport().get_camera_3d(), 0.25, 0.2, 5)
