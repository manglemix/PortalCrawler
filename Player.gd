extends CharacterBody2D

@export var speed = 400

@onready var first = true

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	

func _physics_process(delta):
	if (first):
		get_parent().get_node("leftPortal")._set_partner(get_parent().get_node("rightPortal"))
		get_parent().get_node("rightPortal")._set_partner(get_parent().get_node("leftPortal"))
		first = false
	get_input()
	move_and_slide()
