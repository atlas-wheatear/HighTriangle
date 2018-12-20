extends KinematicBody

# radians per second
const thetaSen = 0.2
const phiSen = 0.5

var camera

# spherical polar coordinates
const r = 2
var phi = 0
var theta = PI/2

# turning values
var turnLeft = 0
var turnRight = 0
var turnDown = 0
var turnUp = 0

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
	
func _process(delta):
	process_input()
	process_movement(delta)
	
func process_input():
	if Input.is_action_pressed("ui_left"):
		turnLeft = 1
	if Input.is_action_pressed("ui_right"):
		turnRight = 1
	if Input.is_action_pressed("ui_up"):
		turnUp = 1
	if Input.is_action_pressed("ui_down"):
		turnDown = 1
	
	if Input.is_action_just_released("ui_left"):
		turnLeft = 0
	if Input.is_action_just_released("ui_right"):
		turnRight = 0
	if Input.is_action_just_released("ui_up"):
		turnUp = 0
	if Input.is_action_just_released("ui_down"):
		turnDown = 0

func process_movement(delta):
	phi += (turnLeft-turnRight) * phiSen * delta
	theta += (turnUp-turnDown) * thetaSen * delta
	theta = clamp(theta, PI/4, PI*3/4)
	
	updateCartesian()
	
	self.move_and_collide(pos-oldPos)
	
	camera.look_at(origin, up)