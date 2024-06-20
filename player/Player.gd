class_name Player
extends CharacterBody3D

signal advancing_level

# exported vars
@export var speed = 5

# stored nodes/scenes for easy reference
@onready var ray = $MainRay
@onready var raydelay = $RayDelay
@onready var AttackArea = $AttackArea

var portal = preload("res://object_scenes/portal.tscn")
var p_bullet = preload("res://object_scenes/portal_bullet.tscn")
var yellowP = preload("res://player/yellow portal.webp")
var purpleP = preload("res://player/purple portal.webp")

var storedTexture

# these are some simple flags for the portal placement code
@onready var firstplaced = false
@onready var secondplaced = false

@onready var next = false

var storedNormal
var storedPosition
var storedCollider

# general vars
var firstPortal
var secondPortal
var target_velocity = Vector3.ZERO
var is_level_finished := false

var adjusting

# hotfix for making sure the node is named properly, remove later
func _ready():
	name = "Player"

# all input from the player is handled here
func _input(_event):
	var direction = Vector3.ZERO
	
	# shooting portals
	if Input.is_action_just_pressed("shoot"):
		if (is_level_finished):
			if (firstplaced):
				if (firstPortal.deletable):
					firstPortal.queue_free()
			if (secondplaced):
				if (secondPortal.deletable):
					secondPortal.queue_free()
			set_process_input(false)
			velocity = Vector3.ZERO
			await get_tree().create_timer(1.5, false).timeout
			advancing_level.emit()
			return
		if (ray.is_colliding() && raydelay.is_stopped()):
			var value = ray.get_collider().position.distance_to(position)
			var bullet = p_bullet.instantiate()
			get_tree().current_scene.add_child(bullet)
			bullet.set_global_position(position)
			bullet.position.y += 2
			bullet.rotation.y = rotation.y
			raydelay.set_wait_time(value / bullet.speed)
			raydelay.start()
			storedCollider = ray.get_collider()
			storedNormal = ray.get_collision_normal()
			storedPosition = ray.get_collision_point()
	if Input.is_action_just_pressed("delete_p"):
		if (!firstplaced && !secondplaced):
			return
		if (firstplaced):
			if (firstPortal.deletable):
				storedTexture = firstPortal.get_node("Sprite3D").get_texture()
				firstPortal.queue_free()
				firstPortal = null
				if (secondplaced):
					secondPortal._set_partner(null)
				firstplaced = false
				return
		if (secondplaced):
			if (secondPortal.deletable):
				storedTexture = secondPortal.get_node("Sprite3D").get_texture()
				secondPortal.queue_free()
				secondPortal = null
				if (firstplaced):
					firstPortal._set_partner(null)
				secondplaced = false
				return
					
	if Input.is_action_just_pressed("attack"):
		if ($Cooldown.is_stopped()):
			var camera := get_viewport().get_camera_3d()
			var mouse_pos := camera.project_position(get_viewport().get_mouse_position(), camera.global_position.y)
			mouse_pos.y = global_position.y
			look_at(mouse_pos)
			$Billboard/CharacterSprite.attack()
			$Windup.start()
		
	# movement
	if Input.is_action_pressed("right"):
		direction.x += 1
		if $Windup.is_stopped():
			rotation.y = - PI / 2
	if Input.is_action_pressed("left"):
		direction.x -= 1
		if $Windup.is_stopped():
			rotation.y = PI / 2
	if Input.is_action_pressed("down"):
		direction.z += 1
		if $Windup.is_stopped():
			rotation.y = PI
	if Input.is_action_pressed("up"):
		direction.z -= 1
		if $Windup.is_stopped():
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


func _on_died() -> void:
	set_physics_process(false)
	
	
# function that creates the portals when the player presses the button to do so
# the reason why the player is handling this code is because all player inputs
# should be handled by the player script when possible
func _create_portal():
	
	var hitobject = storedCollider
	
	if (hitobject.name.begins_with("portal")):
		adjusting = true
	else:
		adjusting = false
	# this block handles the constant cycling of portals as you spawn more and more
	var newportal = portal.instantiate()
	
	# get the position to spawn the portal at
	var rayvector = Vector3.ZERO
	rayvector = storedNormal
	var xposition = storedPosition
	
	# place the new portal at the correct position
	get_tree().current_scene.add_child(newportal)
	newportal.set_global_position(xposition)
	
	# rotate the portal correctly and make sure it knows what way it's facing (for later use)
	if (rayvector.x > .7):
		newportal.update_direction('l')
		if (adjusting):
			newportal.position.x += -0.02433776855469
	elif (rayvector.x < -.7):
		newportal.set_rotation_degrees(Vector3(0, 180, 0))
		newportal.update_direction('r')
		if (adjusting):
			newportal.position.x -= -0.02433776855469
	elif (rayvector.z > .7):
		newportal.set_rotation_degrees(Vector3(0, -90, 0))
		newportal.set_global_position(Vector3(xposition.x, xposition.y, xposition.z))
		newportal.update_direction('u')
		if (adjusting):
			newportal.position.z += -0.02433776855469
	elif (rayvector.z < -.7):
		newportal.set_rotation_degrees(Vector3(0, 90, 0))
		newportal.set_global_position(Vector3(xposition.x, xposition.y, xposition.z))
		newportal.update_direction('d')
		if (adjusting):
			newportal.position.z -= -0.02433776855469
	# make sure the portal updates its stored position
	if (!newportal.update_position()):
		newportal.queue_free()
		return
	
		
	if (!firstplaced || hitobject == firstPortal):
		if (firstPortal != null):
			newportal.get_node("Sprite3D").set_texture(firstPortal.get_node("Sprite3D").get_texture())
			firstPortal.queue_free()
		else:
			if (storedTexture != null && secondplaced):
				newportal.get_node("Sprite3D").set_texture(storedTexture)
				storedTexture = null
			else:
				newportal.get_node("Sprite3D").set_texture(purpleP)
		firstPortal = newportal
		firstplaced = true
		if (secondplaced):
			secondPortal._set_partner(firstPortal)
			firstPortal._set_partner(secondPortal)
	elif (!secondplaced || hitobject == secondPortal):
		if (secondPortal != null):
			newportal.get_node("Sprite3D").set_texture(secondPortal.get_node("Sprite3D").get_texture())
			secondPortal.queue_free()
		else:
			if (storedTexture != null):
				newportal.get_node("Sprite3D").set_texture(storedTexture)
				storedTexture = null
			else:
				newportal.get_node("Sprite3D").set_texture(yellowP)
		secondPortal = newportal
		secondplaced = true
		secondPortal._set_partner(firstPortal)
		firstPortal._set_partner(secondPortal)
	else:
		firstPortal.queue_free()
		firstPortal = secondPortal
		secondPortal = newportal
		if (!next):
			secondPortal.get_node("Sprite3D").set_texture(purpleP)
			next = true
		else:
			secondPortal.get_node("Sprite3D").set_texture(yellowP)
			next = false
		secondPortal._set_partner(firstPortal)
		firstPortal._set_partner(secondPortal)
	storedTexture = null
		

func _on_windup_timeout():
	if (!AttackArea.has_overlapping_bodies()):
		return
	var bodies = AttackArea.get_overlapping_bodies()
	for body in bodies:
		Damageable.damage_node_once(body, 1)
	$Cooldown.start()


func _on_ray_delay_timeout():
	_create_portal()


func _on_level_advanced() -> void:
	set_process_input(true)
	is_level_finished = false


func _on_level_finished() -> void:
	is_level_finished = true
