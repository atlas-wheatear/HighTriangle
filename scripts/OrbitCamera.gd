extends Spatial

# radians per second
const thetaSen = 0.6
const phiSen = 1.0

var camera

# spherical polar coordinates
const r = 2
var phi = 0
var theta = PI/2

var pos = Vector3()
var oldPos = Vector3()

var up = Vector3(0, 1, 0)
var origin = Vector3(0, 0, 0)

func updateCartesian():
	oldPos = pos
	pos.z = r * sin(theta) * cos(phi)
	pos.x = r * sin(theta) * sin(phi)
	pos.y = r * cos(theta)

func _ready():
	camera = $Camera
	add_to_group("Cameras")

func rotateImpulse(phiImpulse, thetaImpulse):
	phi += phiImpulse * phiSen
	theta += thetaImpulse * thetaSen
	theta = clamp(theta, PI/4, PI*3/4)
	
	updateCartesian()
	
	self.translate(pos-oldPos)
	
	camera.look_at(origin, up)
