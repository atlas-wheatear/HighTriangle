tool
extends Spatial

var army_index
var net_index
var type

var army_colors = [Color(1.0, 1.0, 1.0, 1.0), Color(0.2, 0.2, 0.2, 1.0), Color(1.0, 0.0, 0.0, 1.0)]

var position
var rotation_axis
var body_material
var move_helper

# tetrahedral angle
var t_angle = acos(-1.0/3.0)

func _ready():
	add_to_group("pieces")
	rotation_axis = Vector3(0, 1, 0)

func place(arg_move_helper, arg_army_index, arg_net_index, arg_type):
	move_helper = arg_move_helper
	army_index = arg_army_index
	net_index = arg_net_index
	type = arg_type
	
	body_material = SpatialMaterial.new()
	body_material.albedo_color = army_colors[army_index]
	$BodyMesh.set_surface_material(0, body_material)
	
	var lesser_body = get_tree().get_nodes_in_group("lesser_bodies")[net_index]
	var normal = lesser_body.get_normal()
	position = lesser_body.get_centroid()
	var great = lesser_body.get_great()
	
	var rotated_position = position
	
	if great != 0:
		var up = Vector3(0, 1, 0)
		
		rotation_axis = up.cross(normal).normalized()
		
		rotate(rotation_axis, t_angle)
		
		var rotate_transform = Transform()
		rotate_transform = rotate_transform.rotated(rotation_axis, -t_angle)
		rotated_position = rotate_transform * position
	
	translate(rotated_position)

func move(new_net_index):
	var lesser_bodies = get_tree().get_nodes_in_group("lesser_bodies")
	var old_lesser = lesser_bodies[net_index]
	var new_lesser = lesser_bodies[new_net_index]
	
	var rotation_array = move_helper.get_rotate(old_lesser, new_lesser)
	
	var rotated_position = position
	
	if old_lesser.get_great() != 0:
		var rotate_transform = Transform()
		rotate_transform = rotate_transform.rotated(rotation_array[1], t_angle)
		rotated_position = rotate_transform * position
	
	# reset to origin
	translate(-rotated_position)
	
	if rotation_array[0]:
		rotate(rotation_array[1], t_angle)
	
	if rotation_array[2]:
		rotate(rotation_array[3], t_angle)
	
	position = new_lesser.get_centroid()
	rotated_position = position
	
	if new_lesser.get_great() != 0:
		var rotate_transform = Transform()
		rotate_transform = rotate_transform.rotated(rotation_array[3], -t_angle)
		rotated_position = rotate_transform * position
	translate(rotated_position)
	
	net_index = new_net_index

func get_army_index():
	return army_index

func get_net_index():
	return net_index

func get_type():
	return type