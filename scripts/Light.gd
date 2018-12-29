extends DirectionalLight

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func setup(position):
	look_at_from_position(position, Vector3(0,0,0), Vector3(0,1,1))