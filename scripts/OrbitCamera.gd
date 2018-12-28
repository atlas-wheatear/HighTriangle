extends Spatial

# radians per second
const theta_sen = 0.6
const phi_sen = 1.0

var camera

# spherical polar coordinates
const r = 2
var phi = 0
var theta = PI/2

var pos = Vector3()
var old_pos = Vector3()

var up = Vector3(0, 1, 0)
var origin = Vector3(0, 0, 0)

func update_cartesian():
	old_pos = pos
	pos.z = r * sin(theta) * cos(phi)
	pos.x = r * sin(theta) * sin(phi)
	pos.y = r * cos(theta)

func loop_around(angle):
	while angle < 0:
		angle += 2*PI
	while angle > 2*PI:
		angle -= 2*PI
	return angle

func _ready():
	camera = $Camera

func rotate_impulse(phi_impulse, theta_impulse):
	phi += phi_impulse * phi_sen
	phi = loop_around(phi)
	theta += theta_impulse * theta_sen
	theta = clamp(theta, PI/4, PI*3/4)
	
	update_cartesian()
	
	self.translate(pos-old_pos)
	
	camera.look_at(origin, up)
