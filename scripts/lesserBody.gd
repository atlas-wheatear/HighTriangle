extends StaticBody

signal picked

const defaultLesserColor = Color(0.8, 0.8, 0.8, 1.0)
var lesserMeshMaterial
var netIndex
var shape

func _ready():
	add_to_group("lesserBodies")

func getNetIndex():
	return netIndex

func resetColor():
	lesserMeshMaterial.albedo_color = defaultLesserColor

func setColor(color):
	lesserMeshMaterial.albedo_color = color

func setup(argIndex, normal, vertices):
	netIndex = argIndex
	
	self.set_name("lesserBody" + str(netIndex))
	
	lesserMeshMaterial = SpatialMaterial.new()
	lesserMeshMaterial.albedo_color = defaultLesserColor
	
	var surfaceTool = SurfaceTool.new()
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for j in range(3):
		# needed to avoid complaints
		surfaceTool.add_index(j)
		surfaceTool.add_normal(normal)
		surfaceTool.add_vertex(vertices[j])
	
	var mesh = surfaceTool.commit()
	$lesserMesh.mesh = mesh
	$lesserMesh.set_surface_material(0, lesserMeshMaterial)
	
	$lesserCollisionShape.shape = mesh.create_trimesh_shape()