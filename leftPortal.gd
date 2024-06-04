extends StaticBody2D

var collider
var cYOffset
var cXOffset
var p

# Called when the node enters the scene tree for the first time.
func _ready():
	collider = $CollisionShape2D
	cYOffset = self.get_global_position().y
	cXOffset = self.get_global_position().x
	print(cYOffset)
	print(cXOffset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	var bodyY = body.get_global_position().y
	var bodyX = body.get_global_position().x
	body.set_global_position(Vector2((p.cXOffset + (bodyX - cXOffset + 1)), (p.cYOffset + (bodyY - cYOffset + 1))))
	
func _set_partner(partner):
	p = partner
