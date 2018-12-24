extends Spatial

var cameraBody
var camera
var board
var move_helper
var pieces

# scenes
var rookScene
var crownScene
var fersScene
var knightScene
var pawnScene

var turnLeft = 0
var turnRight = 0
var turnDown = 0
var turnUp = 0

func _ready():
	pieces = []
	cameraBody = $OrbitCamera
	camera = $OrbitCamera/Camera
	board = $Board
	
	var ratio = 6
	var s = 2.0
	
	var nl = int(pow(ratio, 2))
	
	board.setup(ratio, s)
	for i in range(4*nl):
		pieces.append([])
	
	move_helper = load("res://scripts/MoveHelper.gd").new()
	move_helper.setup(ratio, pieces, board)
	
	rookScene = load("res://scenes/Rook.tscn")
	var rookInstance = rookScene.instance()
	rookInstance.set_name("rookInstance")
	
	add_child(rookInstance)
	var rookBody = get_tree().get_nodes_in_group("RookBodies")[0]
	rookBody.place(move_helper, 2, 0, 56)
	pieces.append(rookBody)

func _process(delta):
	process_input(delta)
	
func process_input(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mousePosition = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mousePosition)
		var to = from + camera.project_ray_normal(mousePosition) * 10
		var rayCast = get_world().get_direct_space_state().intersect_ray(from, to)
		if not rayCast.empty():
			var collided = rayCast.collider
			var netIndex = collided.getNetIndex()
			var armyIndex = 2
			if move_helper.hostilePieceInNetIndex(armyIndex, netIndex) or move_helper.emptyNetIndex(netIndex):
				var moves = move_helper.getRookMoves(armyIndex, netIndex)
				board.color_moves(netIndex, moves)
	
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