extends Spatial

var cameraBody
var camera
var board
var move_helper

# scenes
var rookScene
var crown_scene
var fersScene
var knight_scene
var pawn_scene

var turnLeft = 0
var turnRight = 0
var turnDown = 0
var turnUp = 0

# game states
var currentNetIndex = -1
var pieceSelected = false
var selectedNetIndex = -1
var captureSelected = false

func _ready():
	var pieces = []
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
	
	rookScene = load("res://scenes/Rook.tscn")
	fersScene = load("res://scenes/Fers.tscn")
	knight_scene = load("res://scenes/Knight.tscn")
	crown_scene = load("res://scenes/Crown.tscn")
	pawn_scene = load("res://scenes/Pawn.tscn")
	
	var rookInstance1 = rookScene.instance()
	rookInstance1.set_name("rookInstance1")
	add_child(rookInstance1)
	var rookBody1 = get_tree().get_nodes_in_group("pieces")[0]
	rookBody1.place(move_helper, 2, 56, "rook")
	pieces[56] = [rookBody1]
	
	var rookInstance2 = rookScene.instance()
	rookInstance2.set_name("rookInstance2")
	add_child(rookInstance2)
	var rookBody2 = get_tree().get_nodes_in_group("pieces")[1]
	rookBody2.place(move_helper, 1, 24, "rook")
	pieces[24] = [rookBody2]
	
	var fersInstance = fersScene.instance()
	fersInstance.set_name("fersInstance")
	add_child(fersInstance)
	var fersBody = get_tree().get_nodes_in_group("pieces")[2]
	fersBody.place(move_helper, 0, 2, "fers")
	pieces[2] = [fersBody]
	
	var knight_instance = knight_scene.instance()
	knight_instance.set_name("knightInstance")
	add_child(knight_instance)
	var knight_body = get_tree().get_nodes_in_group("pieces")[3]
	knight_body.place(move_helper, 1, 10, "knight")
	pieces[10] = [knight_body]
	
	var crown_instance = crown_scene.instance()
	crown_instance.set_name("crownInstance")
	add_child(crown_instance)
	var crown_body = get_tree().get_nodes_in_group("pieces")[4]
	crown_body.place(move_helper, 2, 105, "crown")
	pieces[105] = [crown_body]
	
	var pawn_instance = pawn_scene.instance()
	pawn_instance.set_name("pawnInstance")
	add_child(pawn_instance)
	var pawn_body = get_tree().get_nodes_in_group("pieces")[5]
	pawn_body.place(move_helper, 0, 136, "pawn")
	pieces[136] = [pawn_body]
	
	move_helper.setup(ratio, pieces, board)
	
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if not pieceSelected:
			if event.pressed:
				var mousePosition = get_viewport().get_mouse_position()
				var from = camera.project_ray_origin(mousePosition)
				var to = from + camera.project_ray_normal(mousePosition) * 10
				var rayCast = get_world().get_direct_space_state().intersect_ray(from, to)
				if not rayCast.empty():
					var collided = rayCast.collider
					currentNetIndex = collided.getNetIndex()
			else:
				if currentNetIndex > 0:
					if not move_helper.emptyNetIndex(currentNetIndex):
						var moves = move_helper.getMoves(currentNetIndex)
						board.color_moves(currentNetIndex, moves)
						pieceSelected = true
		else:
			if event.pressed:
				var mousePosition = get_viewport().get_mouse_position()
				var from = camera.project_ray_origin(mousePosition)
				var to = from + camera.project_ray_normal(mousePosition) * 10
				var rayCast = get_world().get_direct_space_state().intersect_ray(from, to)
				if not rayCast.empty():
					var collided = rayCast.collider
					selectedNetIndex = collided.getNetIndex()
					captureSelected = true
			else:
				if captureSelected:
					if selectedNetIndex != currentNetIndex:
						if move_helper.legal_move(currentNetIndex, selectedNetIndex):
							move_helper.move(currentNetIndex, selectedNetIndex)
							pieceSelected = false
							captureSelected = false
							board.reset_colors()
					else:
						pieceSelected = false
						captureSelected = false
						board.reset_colors()

func _process(delta):
	process_input(delta)

func process_input(delta):
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