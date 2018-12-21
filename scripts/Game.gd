extends Spatial

var cameraBody
var camera
var board

var turnLeft = 0
var turnRight = 0
var turnDown = 0
var turnUp = 0

var ratio
var s

func _ready():
	cameraBody = $OrbitCamera
	camera = $OrbitCamera/Camera
	board = $Board
	
	ratio = 6
	s = 2.0
	
	board.setup(ratio, s)

func _process(delta):
	process_input(delta)
	
func process_input(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mousePosition = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mousePosition)
		var to = from + camera.project_ray_normal(mousePosition) * 20
		var rayCast = get_world().get_direct_space_state().intersect_ray(from, to)
		if not rayCast.empty():
			var lesser = rayCast.collider
			lesser.setColor(Color(1.0, 0.0, 0.0, 1.0))
	
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
	
	var phiImpulse = (turnLeft-turnRight) * delta
	var thetaImpulse = (turnUp-turnDown) * delta
	
	cameraBody.rotateImpulse(phiImpulse, thetaImpulse)