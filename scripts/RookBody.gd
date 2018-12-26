extends KinematicBody

var armyIndex
var pieceIndex
var netIndex

var armyColors = [Color(1.0, 1.0, 1.0, 1.0), Color(0.2, 0.2, 0.2, 1.0), Color(1.0, 0.0, 0.0, 1.0)]

var position
var rotationAxis
var rotationAngle
var rookBodyMaterial
var moveHelper

# tetrahedral angle
var tAngle = acos(-1.0/3.0)

func _ready():
	add_to_group("RookBodies")
	rotationAngle = 0
	rotationAxis = Vector3(0, 1, 0)

func place(argMoveHelper, argArmyIndex, argPieceIndex, argNetIndex):
	moveHelper = argMoveHelper
	armyIndex = argArmyIndex
	pieceIndex = argPieceIndex
	netIndex = argNetIndex
	
	rookBodyMaterial = SpatialMaterial.new()
	rookBodyMaterial.albedo_color = armyColors[armyIndex]
	$rookGodot.set_surface_material(0, rookBodyMaterial)
	
	var lesserBody = get_tree().get_nodes_in_group("lesserBodies")[netIndex]
	var normal = lesserBody.getNormal()
	position = lesserBody.getCentroid()
	var great = lesserBody.getGreat()
	
	if great != 0:
		var up = Vector3(0, 1, 0)
		
		rotationAngle = acos(normal.dot(up))
		
		rotationAxis = up.cross(normal).normalized()
		
		rotate(rotationAxis, rotationAngle)
	move_and_collide(position)

func move(newNetIndex):
	var lesserBodies = get_tree().get_nodes_in_group("lesserBodies")
	var oldLesser = lesserBodies[netIndex]
	var newLesser = lesserBodies[newNetIndex]
	
	# reset to origin
	move_and_collide(-position)
	
	var rotationArray = moveHelper.getRotate(oldLesser, newLesser)
	
	if rotationArray[0]:
		rotate(rotationArray[1], tAngle)
	
	if rotationArray[2]:
		rotate(rotationArray[3], tAngle)
	
	position = newLesser.getCentroid()
	move_and_collide(position)
	
	netIndex = newNetIndex

func getArmyIndex():
	return armyIndex

func getPieceIndex():
	return pieceIndex

func getNetIndex():
	return netIndex

func isPiece():
	return true

func getType():
	return "rook"