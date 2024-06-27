class_name Player
extends CharacterBody3D

signal advancing_level
signal reset_game
signal appeared

# exported vars
@export var speed = 5

# stored nodes/scenes for easy reference
@onready var ray = $MainRay
@onready var raydelay = $RayDelay
@onready var AttackArea = $AttackArea

var portal = preload("res://player/portal/portal.tscn")
var p_bullet = preload("res://player/portal/portal_bullet.tscn")


# these are some simple flags for the portal placement code
@onready var firstplaced = false
@onready var secondplaced = false


var storedNormal
var storedPosition
var storedCollider

# general vars
var firstPortal
var secondPortal
var target_velocity = Vector3.ZERO
var is_level_finished := false
var is_teleporting := false

var adjusting

@onready var leftheld = false
@onready var rightheld = false
@onready var downheld = false
@onready var upheld = false

@onready var switch = false
@onready var neg_x = false
@onready var neg_z = false
@onready var sprite: CharacterSprite = $Billboard/CharacterSprite

# hotfix for making sure the node is named properly, remove later
func _ready():
	name = "Player"
	$MeshInstance3D.hide()
	set_physics_process(false)
	set_process_input(false)
	sprite.set_process(false)
	sprite.play(&"unsit")
	await sprite.animation_finished
	$MeshInstance3D.show()
	sprite.set_process(true)
	set_physics_process(true)
	set_process_input(true)
	appeared.emit()


func aim_at_mouse() -> void:
	var camera := get_viewport().get_camera_3d()
	var mouse_pos := camera.project_position(get_viewport().get_mouse_position(), camera.global_position.y)
	mouse_pos.y = global_position.y
	look_at(mouse_pos)


# all input from the player is handled here
func _input(_event):
	if Input.is_action_just_pressed("attack"):
		if is_level_finished:
			return
		if ($Cooldown.is_stopped() and !sprite.animation.contains("attack")):
			$Swing.play()
			aim_at_mouse()
			sprite.attack()
			$Windup.start()
	elif Input.is_action_just_pressed("shoot"):
		# Level to level portals
		if (is_level_finished):
			if (firstplaced):
				firstplaced = false
				firstPortal.queue_free()
			if (secondplaced):
				secondplaced = false
				secondPortal.queue_free()
			sprite.set_process(false)
			$MeshInstance3D.hide()
			sprite.play(&"sit")
			is_teleporting = true
			set_process_input(false)
			velocity = Vector3.ZERO
			await sprite.animation_finished
			advancing_level.emit()
			return
		
		# Check if we're deleting portals
		if (firstplaced):
			if (firstPortal.deletable):
				#storedTexture = firstPortal.get_node("Sprite3D").get_texture()
				firstPortal.queue_free()
				firstPortal = null
				if (secondplaced):
					secondPortal._set_partner(null)
				firstplaced = false
				return
		if (secondplaced):
			if (secondPortal.deletable):
				#storedTexture = secondPortal.get_node("Sprite3D").get_texture()
				secondPortal.queue_free()
				secondPortal = null
				if (firstplaced):
					firstPortal._set_partner(null)
				secondplaced = false
				return
		
		# shooting portals
		aim_at_mouse()
		ray.force_raycast_update()
		if (ray.is_colliding() && raydelay.is_stopped()):
			var value = ray.get_collider().global_position.distance_to(global_position)
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
			$Swing.play()
			sprite.attack()


func _physics_process(_delta):
	_get_movement()
	move_and_slide()

func _get_movement():
	if !is_processing_input():
		return
			
	var direction = Vector3.ZERO
	velocity = Vector3.ZERO
	# movement
	if Input.is_action_pressed("right"):
		direction.x += 1
		if $Windup.is_stopped():
			rotation.y = - PI / 2
	else:
		rightheld = false
	if Input.is_action_pressed("left"):
		direction.x -= 1
		if $Windup.is_stopped():
			rotation.y = PI / 2
	else:
		leftheld = false
	if Input.is_action_pressed("down"):
		direction.z += 1
		if $Windup.is_stopped():
			rotation.y = PI
	else:
		downheld = false
	if Input.is_action_pressed("up"):
		direction.z -= 1
		if $Windup.is_stopped():
			rotation.y = 0.0
	else:
		upheld = false
	

		
	# applying movement
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	if (target_velocity == Vector3.ZERO):
			return
	target_velocity = change_input(target_velocity)
	velocity = target_velocity

func _on_damaged(_health_change: int) -> void:
	Shake.shake_node(get_viewport().get_camera_3d(), 0.25, 0.2, 5)


func _on_died() -> void:
	if (firstplaced):
		firstplaced = false
		firstPortal.queue_free()
	if (secondplaced):
		secondplaced = false
		secondPortal.queue_free()
	set_physics_process(false)
	set_process_input(false)
	
	
# function that creates the portals when the player presses the button to do so
# the reason why the player is handling this code is because all player inputs
# should be handled by the player script when possible
func _create_portal():
	
	var hitobject = storedCollider
	if (!is_instance_valid(hitobject)):
		return
	
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
			newportal.position.x += -0.06180000305176
	elif (rayvector.x < -.7):
		newportal.set_rotation_degrees(Vector3(0, 180, 0))
		newportal.update_direction('r')
		if (adjusting):
			newportal.position.x -= -0.06180000305176
	elif (rayvector.z > .7):
		newportal.set_rotation_degrees(Vector3(0, -90, 0))
		newportal.set_global_position(Vector3(xposition.x, xposition.y, xposition.z))
		newportal.update_direction('u')
		if (adjusting):
			newportal.position.z += -0.06180000305176
	elif (rayvector.z < -.7):
		newportal.set_rotation_degrees(Vector3(0, 90, 0))
		newportal.set_global_position(Vector3(xposition.x, xposition.y, xposition.z))
		newportal.update_direction('d')
		if (adjusting):
			newportal.position.z -= -0.06180000305176
	# make sure the portal updates its stored position
	if (!newportal.update_position()):
		newportal.queue_free()
		return
		
	if (!firstplaced || hitobject == firstPortal):
		if (firstPortal != null):
			firstPortal.queue_free()
		firstPortal = newportal
		firstplaced = true
		if (secondplaced):
			secondPortal._set_partner(firstPortal)
			firstPortal._set_partner(secondPortal)
	elif (!secondplaced || hitobject == secondPortal):
		if (secondPortal != null):
			secondPortal.queue_free()
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
	

func _on_windup_timeout():
	if (!AttackArea.has_overlapping_bodies()):
		return
	var bodies = AttackArea.get_overlapping_bodies()
	for body in bodies:
		Damageable.damage_node_once(body, 1)
	$Cooldown.start()

@warning_ignore("shadowed_variable")
func change_input(target_velocity):
	if (!leftheld && !rightheld && !upheld && !downheld):
		return target_velocity
	if (neg_x):
		target_velocity.x = -target_velocity.x 
	if (neg_z):
		target_velocity.z = -target_velocity.z
	if (switch):
		var temp = target_velocity.x
		target_velocity.x = target_velocity.z
		target_velocity.z = temp
		
	if $Windup.is_stopped():
		if (target_velocity.x < 0):
			rotation.y =  PI / 2
		elif (target_velocity.x < 0):
			rotation.y = - PI / 2
		elif (target_velocity.z > 0):
			rotation.y = PI
		else:
			rotation.y = 0.0
	return target_velocity
	
func set_input_change(g_switch: bool, g_xneg: bool, g_zneg: bool):
	switch = g_switch
	neg_x = g_xneg
	neg_z = g_zneg


func _on_ray_delay_timeout():
	_create_portal()


func _on_level_advanced() -> void:
	is_level_finished = false
	$MeshInstance3D.hide()
	sprite.play(&"unsit")
	await sprite.animation_finished
	is_teleporting = false
	appeared.emit()
	$MeshInstance3D.show()
	
	var health: Health = $Health
	if health.health == 0:
		health.health = health.max_health
		sprite.reset()
	else:
		health.health += 1
		sprite.set_process(true)
	
	set_physics_process(true)
	set_process_input(true)


func _on_level_finished() -> void:
	is_level_finished = true

func _on_death_animation_finished() -> void:
	is_teleporting = true
	reset_game.emit()
