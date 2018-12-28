extends Spatial

var camera_body
var camera
var board
var move_helper

# scenes
var rook_scene
var crown_scene
var fers_scene
var knight_scene
var pawn_scene

var turn_left = 0
var turn_right = 0
var turn_down = 0
var turn_up = 0

# game states
var current_net_index = -1
var piece_selected = false
var selected_net_index = -1
var capture_selected = false

func _ready():
	var pieces = []
	camera_body = $OrbitCamera
	camera = $OrbitCamera/Camera
	board = $Board
	
	var ratio = 6
	var s = 2.0
	
	var nl = int(pow(ratio, 2))
	
	board.setup(ratio, s)
	for i in range(4*nl):
		pieces.append([])
	
	move_helper = load("res://scripts/MoveHelper.gd").new()
	
	rook_scene = load("res://scenes/Rook.tscn")
	
	var rook_instance = rook_scene.instance()
	rook_instance.set_name("rook_instance")
	add_child(rook_instance)
	var rook_body = get_tree().get_nodes_in_group("pieces")[0]
	rook_body.place(move_helper, 2, 56, "rook")
	pieces[56] = [rook_body]
	
	move_helper.setup(ratio, pieces, board)
	
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		var mouse_position = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mouse_position)
		var to = from + camera.project_ray_normal(mouse_position) * 10
		var raycast = get_world().get_direct_space_state().intersect_ray(from, to)
		if not raycast.empty():
			var collided = raycast.collider
			if not piece_selected:
				current_net_index = collided.get_net_index()
				if not move_helper.empty_net_index(current_net_index):
					var moves = move_helper.get_moves(current_net_index)
					board.color_moves(current_net_index, moves)
					piece_selected = true
			else:
				selected_net_index = collided.get_net_index()
				if selected_net_index != current_net_index:
					if move_helper.legal_move(current_net_index, selected_net_index):
						move_helper.move(current_net_index, selected_net_index)
						piece_selected = false
						capture_selected = false
						board.reset_colors()
				else:
					piece_selected = false
					capture_selected = false
					board.reset_colors()

func _process(delta):
	process_input(delta)

func process_input(delta):
	if Input.is_action_pressed("ui_left"):
		turn_left = 1
	if Input.is_action_pressed("ui_right"):
		turn_right = 1
	if Input.is_action_pressed("ui_up"):
		turn_up = 1
	if Input.is_action_pressed("ui_down"):
		turn_down = 1
	
	if Input.is_action_just_released("ui_left"):
		turn_left = 0
	if Input.is_action_just_released("ui_right"):
		turn_right = 0
	if Input.is_action_just_released("ui_up"):
		turn_up = 0
	if Input.is_action_just_released("ui_down"):
		turn_down = 0
	
	var phi_impulse = (turn_left-turn_right) * delta
	var theta_impulse = (turn_up-turn_down) * delta
	
	camera_body.rotate_impulse(phi_impulse, theta_impulse)