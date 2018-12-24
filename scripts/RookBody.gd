extends KinematicBody

var armyIndex
var pieceIndex
var netIndex

var position
var rotationAxis
var rotationAngle

func _ready():
	add_to_group("RookBodies")

func place(argArmyIndex, argPieceIndex, argNetIndex):
	armyIndex = argArmyIndex
	pieceIndex = argPieceIndex
	netIndex = argNetIndex
	
	var lesserBody = get_tree().get_nodes_in_group("lesserBodies")[netIndex]
	var normal = lesserBody.getNormal()
	position = lesserBody.getCentroid()
	
	var up = Vector3(0, 1, 0)
	
	rotationAngle = acos(normal.dot(up))
	
	rotationAxis = up.cross(normal).normalized()
	
	rotate(rotationAxis, rotationAngle)
	move_and_collide(position)
	
func getArmyIndex():
	return armyIndex

func getPieceIndex():
	return pieceIndex

func getNetIndex():
	return netIndex

func isPiece():
	return true