extends StaticBody3D


var collider
var cZOffset
var cXOffset
var p

# Called when the node enters the scene tree for the first time.
func _ready():
	collider = $CollisionShape2D
	cZOffset = self.get_global_position().z
	cXOffset = self.get_global_position().x
	print(cZOffset)
	print(cXOffset)


func _set_partner(partner):
	p = partner


func _on_area_3d_body_entered(body):
	var bodyY = body.get_global_position().y
	var bodyX = body.get_global_position().x
	var bodyZ = body.get_global_position().z
	body.set_global_position(Vector3((p.cXOffset - (bodyX - cXOffset - .05)), bodyY, (p.cZOffset - (bodyZ - cZOffset - .05))))
