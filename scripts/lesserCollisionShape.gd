extends CollisionShape

func _ready():
	set_process_input(true)
	connect("input_event", self, "_input_event")

func _input_event(camera, event, click_position, click_normal, shape_idx):
	print("Clicked")