extends KinematicBody

var armyIndex
var pieceIndex
var netIndex

var position
var rotationAxis
var rotationAngle
var great

func _ready():
	add_to_group("RookBodies")
	rotationAngle = 0
	rotationAxis = Vector3(0, 1, 0)

func place(argArmyIndex, argPieceIndex, argNetIndex):
	armyIndex = argArmyIndex
	pieceIndex = argPieceIndex
	netIndex = argNetIndex
	
	var lesserBody = get_tree().get_nodes_in_group("lesserBodies")[netIndex]
	var normal = lesserBody.getNormal()
	position = lesserBody.getCentroid()
	great = lesserBody.getGreat()
	
	if great != 0:
		var up = Vector3(0, 1, 0)
		
		rotationAngle = acos(normal.dot(up))
		
		rotationAxis = up.cross(normal).normalized()
		
		rotate(rotationAxis, rotationAngle)
	move_and_collide(position)

func move(newNetIndex):
	var lesserBody = get_tree().get_nodes_in_group("lesserBodies")[newNetIndex]
	var newGreat = lesserBody.getGreat()
	
	# reset to origin
	move_and_collide(-position)
	
	# if both greats are not both 0
	if great != 0:
		rotate(rotationAxis, -rotationAngle)
	
	if newGreat != 0:
		var normal = lesserBody.getNormal()
		
		var up = Vector3(0, 1, 0)
		
		rotationAngle = acos(normal.dot(up))
		
		rotationAxis = up.cross(normal).normalized()
		
		rotate(rotationAxis, rotationAngle)
	
	position = lesserBody.getCentroid()
	move_and_collide(position)
	
	netIndex = newNetIndex
	great = newGreat

func getArmyIndex():
	return armyIndex

func getPieceIndex():
	return pieceIndex

func getNetIndex():
	return netIndex

func isPiece():
	return true