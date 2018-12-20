extends StaticBody

signal picked

const defaultLesserColor = Color(0.9, 0.9, 0.9, 1.0)
var lesserMeshMaterial
var index
var shape

func _ready():
	add_to_group("lesserBodies")

func resetColor():
	lesserMeshMaterial.albedo_color = defaultLesserColor

func setColor(color):
	lesserMeshMaterial.albedo_color = color

func setup(argIndex, normal, vertices):
	index = argIndex
	self.set_name("lesserBody")
	$lesserMesh.set_name("lesserMesh")
	
	lesserMeshMaterial = SpatialMaterial.new()
	lesserMeshMaterial.albedo_color = defaultLesserColor
	lesserMeshMaterial.set_name("lesserMeshMaterial")
	
	var surfaceTool = SurfaceTool.new()
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for j in range(3):
		surfaceTool.add_normal(normal)
		surfaceTool.add_vertex(vertices[j])
	
	var mesh = surfaceTool.commit()
	$lesserMesh.mesh = mesh
	$lesserMesh.set_surface_material(0, lesserMeshMaterial)
	
	$lesserCollisionShape.shape = mesh.create_trimesh_shape()