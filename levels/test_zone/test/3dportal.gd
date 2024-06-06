extends StaticBody3D


var collider
var cZOffset
var cXOffset
var p

var facing

# Called when the node enters the scene tree for the first time.
func _ready():
	collider = $CollisionShape2D
	cZOffset = self.get_global_position().z
	cXOffset = self.get_global_position().x
	
	facing = ''


func _set_partner(partner):
	p = partner


func _on_area_3d_body_entered(body):
	var bodyY = body.get_global_position().y
	var bodyX = body.get_global_position().x
	var bodyZ = body.get_global_position().z
	
	
	body.set_global_position(Vector3(p.cXOffset + .1, bodyY, p.cZOffset))
