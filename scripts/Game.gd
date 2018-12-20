extends Spatial

var camera

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	camera = $OrbitCamera/Camera


func _process(delta):
	process_input()
	
func process_input():
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mousePosition = get_viewport().get_mouse_position()
		var from = camera.project_ray_origin(mousePosition)
		var to = from + camera.project_ray_normal(mousePosition) * 20
		var rayCast = get_world().get_direct_space_state().intersect_ray(from, to)
		if not rayCast.empty():
			var lesser = rayCast.collider
			lesser.setColor(Color(1.0, 0.0, 0.0, 1.0))