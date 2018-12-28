extends StaticBody

const default_lesser_color = Color(0.8, 0.8, 0.8, 1.0)
var lesser_mesh_material
var net_index
var shape
var centroid = Vector3(0.0, 0.0, 0.0)
var normal
var great

func _ready():
	add_to_group("lesser_bodies")

func get_great():
	return great

func get_net_index():
	return net_index

func get_centroid():
	return centroid

func get_normal():
	return normal

func reset_color():
	lesser_mesh_material.albedo_color = default_lesser_color

func set_color(color):
	lesser_mesh_material.albedo_color = color

func setup(arg_great, arg_net_index, arg_normal, vertices):
	great = arg_great
	normal = arg_normal
	net_index = arg_net_index
	
	self.set_name("lesserBody" + str(net_index))
	
	lesser_mesh_material = SpatialMaterial.new()
	lesser_mesh_material.albedo_color = default_lesser_color
	
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for j in range(3):
		# needed to avoid complaints
		surface_tool.add_index(j)
		surface_tool.add_normal(normal)
		surface_tool.add_vertex(vertices[j])
		
		# sum vectors
		centroid += vertices[j]
	
	centroid /= 3.0
	surface_tool.index()
	var mesh = surface_tool.commit()
	$lesserMesh.mesh = mesh
	$lesserMesh.set_surface_material(0, lesser_mesh_material)
	$lesserCollisionShape.shape = mesh.create_trimesh_shape()