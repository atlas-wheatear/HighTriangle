extends Node

# left- and rightmost lessers of each NET row
var leftmosts = []
var rightmosts = []

var edgeMoves = []
var vertexMoves = []

var rookRows = []
var rookColumns = []

var ratio
var nl

var board

var pieces = []

# right-most value of a given net-row
func populateRightmosts():
	for i in range(2*ratio):
		rightmosts.append((4*ratio-2)*(i+1)-int(pow(i,2)))
    
func scanForRookMoves(armyIndex, line, moves):
	# iterate through line
	for iNetIndex in line:
		# if hostile piece in iNetIndex
		if hostilePieceInNetIndex(armyIndex, iNetIndex):
			# calculate move
			var move = [iNetIndex, true]
			 
			# if move is not already in moves
			if not moves.has(move):
				# append move to moves
				moves.append(move)
                       
			# end of chain, break
			break
		elif friendlyPieceInNetIndex(armyIndex, iNetIndex):
			# end of chain, break
			break
		else:
			# calculate move
			var move = [iNetIndex, false]
                
			# if move is not already in moves
			if not moves.has(move):
				# append move to moves
				moves.append(move)
				   
	# return moves
	return moves

# left-most value of a given net-row
func populateLeftmosts():
	for i in range(2*ratio):
		leftmosts.append((4*ratio-i)*i)

func hostilePieceInNetIndex(armyIndex, netIndex):
	# iterate through pieces
	
	var piece = pieces[netIndex]
	
	if piece.empty():
		return false
	
	if armyIndex != piece[0]:
		return true
	
	return false

func friendlyPieceInNetIndex(armyIndex, netIndex):
	var piece = pieces[netIndex]
	
	if piece.empty():
		return false
	
	if armyIndex == piece[0]:
		return true
	
	return false
	
func emptyNetIndex(netIndex):
	var piece = pieces[netIndex]
	
	if piece.empty():
		return true
	
	return false

func getNetRow(netIndex):
	# iterate through each row (no rows = ratio*2)
	for i in range(ratio*2):
		# if netIndex is leq to index of rightmost lesser of row i
		if netIndex <= rightmosts[i]:
			# return row number
			return i

# returns True if triangle is up /\, False if it is down \/
func isUp(netIndex):
	# get row of netIndex
	var netRow = getNetRow(netIndex)
	
	# get leftmost of netRow
	var leftMost = leftmosts[netRow]
	
	# every leftmost is a down triangle
	# if an odd number of triangles along from leftmost
	if int(netIndex-leftMost) % 2 == 1:
		# triangle is up
		return true
            
	# it is even, and hence triangle is down
	return false

# move alpha in direction down left / on NET
func moveAlphaDownLeft(netIndex):
	# if triangle is down
	if not isUp(netIndex):
		# return decremented netIndex
		return netIndex-1
        
	# hence triangle is up
	# get net row
	var netRow = getNetRow(netIndex)
        
	# get leftmost
	var leftMost = leftmosts[netRow]
        
	# get leftmost of row below
	var leftMostBelow = leftmosts[netRow+1]
        
	# calculate displacement from leftmost
	var d = netIndex-leftMost
        
	# return the leftMostBelow summed with (d-1)
	return leftMostBelow + d-1

# move alpha up right / on NET
func moveAlphaUpRight(netIndex):
	# if triangle is up
	if isUp(netIndex):
		# return incremented netIndex
		return netIndex+1
       
	# hence triangle is down
	# get net row
	var netRow = getNetRow(netIndex)
       
	# get left-most
	var leftMost = leftmosts[netRow]
       
	# get leftMost of row above
	var leftMostAbove = leftmosts[netRow-1]
       
	# calculate displacement from leftMost
	var d = netIndex-leftMost

	# return leftMostBelow added to (d+1)
	return leftMostAbove + (d+1)

# move in direction <- on NET
func moveLeft(netIndex):
	return netIndex-1
    
# move in direction -> on NET
func moveRight(netIndex):
	return netIndex+1

# move in direction ^ on NET
func moveUp(netIndex):
	# calculate netRow
	var netRow = getNetRow(netIndex)
        
	# calculate leftmost
	var leftMost = leftmosts[netRow]
        
	# calculate leftMost of row above
	var leftMostAbove = leftmosts[netRow-1]
        
	# calculate distance from leftMost
	var d = netIndex - leftMost
        
	# return leftMostAbove + (d+1)
	return leftMostAbove + (d+1)

# move in direction v on net
func moveDown(netIndex):
	# calculate netRow
	var netRow = getNetRow(netIndex)
        
	# calculate leftMost
	var leftMost = leftmosts[netRow]
        
	# calculate leftMost of row below
	var leftMostBelow = leftmosts[netRow+1]
        
	# calculate distance from leftMost
	var d = netIndex - leftMost
        
	# return leftMostBelow + (d-1)
	return leftMostBelow + (d-1)

# move alpha down right \ on NET
func moveAlphaDownRight(netIndex):
	# if triangle is down
	if not isUp(netIndex):
		# return incremented netIndex
		return netIndex+1
        
	# hence triangle is up
	# get net row
	var netRow = getNetRow(netIndex)
        
	# get right-most
	var rightMost = rightmosts[netRow]
        
	# get right-most of row below
	var rightMostBelow = rightmosts[netRow+1]
        
	# calculate distance from right-most
	var d = rightMost-netIndex
        
	# return rightMostBelow - (d-1)
	return rightMostBelow - (d-1)

# move alpha up left \ on NET
func moveAlphaUpLeft(netIndex):
	# if triangle is up
	if isUp(netIndex):
		# return decremented netIndex
		return netIndex-1
        
	# hence triangle is down
	# get net row
	var netRow = getNetRow(netIndex)
        
	# get right-most
	var rightMost = rightmosts[netRow]
        
	# get right-most of row below
	var rightMostAbove = rightmosts[netRow-1]
        
	# calculate distance from right-most
	var d = rightMost-netIndex
        
	# return rightMostBelow - (d+1)
	return rightMostAbove - (d+1)

# move beta down left / on NET
func moveBetaDownLeft(netIndex):
	# if triangle is down
	if not isUp(netIndex):
		# return decremented netIndex
		return netIndex-1
        
	# hence triangle is up
	# calculate netRow
	var netRow = getNetRow(netIndex)
        
	# calculate rightMost of netRow
	var rightMost = rightmosts[netRow]
        
	# calculate rightMost of below netRow
	var rightMostBelow = rightmosts[netRow+1]
        
	# calculate distance from rightMost
	var d = rightMost-netIndex
        
	# return rightMostBelow with (d+1) subtracted
	return rightMostBelow - (d+1)

# move beta up right / on NET
func moveBetaUpRight(netIndex):
	# if triangle is up
	if isUp(netIndex):
		# return incremented netIndex
		return netIndex+1
        
	# hence triangle is down
	# calculate netRow
	var netRow = getNetRow(netIndex)
        
	# calculate rightMost of netRow
	var rightMost = rightmosts[netRow]
        
	# calculate rightmost of above netRow
	var rightMostAbove = rightmosts[netRow-1]
        
	# calculate distance from rightMost
	var d = rightMost-netIndex
        
	# return rightMostAbove with (d-1) subtracted
	return rightMostAbove - (d-1)

# move beta down right \ on NET
func moveBetaDownRight(netIndex):
	# if triangle is down
	if not isUp(netIndex):
		# return incremented netIndex
		return netIndex+1
        
	# hence triangle is up
	# calculate netRow
	var netRow = getNetRow(netIndex)
        
	# calculate leftMost of netRow
	var leftMost = leftmosts[netRow]
        
	# calculate leftMost of below netRow
	var leftMostBelow = leftmosts[netRow+1]
        
	# calculate distance from leftMost
	var d = netIndex-leftMost
        
	# return leftMostBelow with (d+1) added
	return leftMostBelow + d+1

# move beta up left \ on NET
func moveBetaUpLeft(netIndex):
	# if triangle is up
	if isUp(netIndex):
		# return decremented netIndex
		return netIndex-1
        
	# hence triangle is down
	# calculate netRow
	var netRow = getNetRow(netIndex)
        
	# calculate leftMost of netRow
	var leftMost = leftmosts[netRow]
        
	# calculate leftMost of above netRow
	var leftMostAbove = leftmosts[netRow-1]
        
	# calculate distance from leftMost
	var d = netIndex-leftMost
        
	# return leftMostAbove with (d-1) added
	return leftMostAbove + d-1

func moveOnNet(netIndex, motion):
	match motion:
		"left":
			netIndex = moveLeft(netIndex)
		"right":
			netIndex = moveRight(netIndex)
		"up":
			netIndex = moveUp(netIndex)
		"down":
			netIndex = moveDown(netIndex)
		"alphaDownLeft": 
			netIndex = moveAlphaDownLeft(netIndex) 
		"alphaDownRight":
			netIndex = moveAlphaDownRight(netIndex)
		"alphaUpLeft":
			netIndex = moveAlphaUpLeft(netIndex)
		"alphaUpRight":
			netIndex = moveAlphaUpRight(netIndex)
		"betaUpLeft":
			netIndex = moveBetaUpLeft(netIndex)
		"betaUpRight":
			netIndex = moveBetaUpRight(netIndex)
		"betaDownLeft":
			netIndex = moveBetaDownLeft(netIndex)
		"betaDownRight":
			netIndex = moveBetaDownRight(netIndex)
	
	return netIndex

func populateEdgeMoves():
	edgeMoves = []
	
	for i in range(4*nl):
		edgeMoves.append([])
	
	for i in range(4*nl):
		# if up triangle
		if isUp(i):
			# trivial motion
			edgeMoves[i].append(moveAlphaUpLeft(i))
			edgeMoves[i].append(moveDown(i))
			edgeMoves[i].append(moveAlphaUpRight(i))
		else:
			# non-trivial motion
			var great = board.getGreat(i)
			
			# alpha down left motion
			# if leftmost netIndex
			if leftmosts.has(i):
				var row = getNetRow(i)
				var nextRow = 2*ratio - row - 1
				edgeMoves[i].append(leftmosts[nextRow])
			# not leftmost netIndex
			else:
				edgeMoves[i].append(moveAlphaDownLeft(i))
			
			# alpha down right motion
			# if rightmost netIndex
			if rightmosts.has(i):
				var row = getNetRow(i)
				var nextRow = 2*ratio - row -1
				edgeMoves[i].append(rightmosts[nextRow])
			# not rightmost netIndex
			else:
				edgeMoves[i].append(moveAlphaDownRight(i))
			
			# up motion
			# if netIndex in top row
			if getNetRow(i) == 0:
				edgeMoves[i].append(4*ratio - 2 - i)
			# not in top row
			else:
				edgeMoves[i].append(moveUp(i))

func populateVertexMoves():
	vertexMoves = []
	for i in range(4*nl):
		vertexMoves.append([])
	
	# iterate through lessers
	for i in range(4*nl):
		# if up
		if isUp(i):
			# moving up
			# if not illegal position
			if i != 2*ratio-1:
				# if top most
				if getNetRow(i) == 0:
					vertexMoves[i].append(4*ratio-2-i)
				# not top most
				else:
					vertexMoves[i].append(moveUp(i))
			
			# moving beta down right
			# if not illegal position
			if i != rightmosts[ratio-1]-1:
				# if one less than rightmost
				if rightmosts.has(i+1):
					var row = getNetRow(i)
					var nextRow = 2*ratio-row-2
					vertexMoves[i].append(rightmosts[nextRow]-1)
				# not one less than rightmost
				else:
					vertexMoves[i].append(moveBetaDownRight(i))
			
			# moving beta down left
			# if not illegal position
			if i != leftmosts[ratio-1]+1:
				# if one more than leftmost
				if leftmosts.has(i-1):
					var row = getNetRow(i)
					var nextRow = 2*ratio-row-2
					vertexMoves[i].append(leftmosts[nextRow]+1)
				# not one more than leftmost
				else:
					vertexMoves[i].append(moveBetaDownLeft(i))
		# is down
		else:
			# moving down
			# if not illegal position
			if i != 4*nl-1 and i != leftmosts[ratio-1] and i != rightmosts[ratio-1]:
				# if in leftmosts
				
				if leftmosts.has(i):
					var row = getNetRow(i)
					var nextRow = 2*ratio-row-2
					vertexMoves[i].append(leftmosts[nextRow])
				# else if in rightmosts
				elif rightmosts.has(i):
					var row = getNetRow(i)
					var nextRow = 2*ratio-row-2
					vertexMoves[i].append(rightmosts[nextRow])
				else:
					vertexMoves[i].append(moveDown(i))
			
			# moving beta up right
			# if not illegal position
			if i != 4*ratio-2 and i != 2*ratio-2 and i != rightmosts[ratio]:
				# if in rightmosts
				if rightmosts.has(i):
					var row = getNetRow(i)
					var nextRow = 2*ratio-row
					vertexMoves[i].append(rightmosts[nextRow])
				# else if top row
				elif getNetRow(i) == 0:
					vertexMoves[i].append(4*ratio-4-i)
				else:
					vertexMoves[i].append(moveBetaUpRight(i))
			
			# moving beta up left
			# if not illegal position
			if i != 0 and i != 2*ratio and i != leftmosts[ratio]:
				# if i in leftmosts
				if leftmosts.has(i):
					var row = getNetRow(i)
					var nextRow = 2*ratio-row
					vertexMoves[i].append(leftmosts[nextRow])
				# else if top row
				elif getNetRow(i) == 0:
					vertexMoves[i].append(4*ratio-i)
				else:
					vertexMoves[i].append(moveBetaUpLeft(i))

func getRotate(oldLesser, newLesser):
	var returnArray = []
	var up = Vector3(0, 1, 0)
	
	for i in range(4):
		returnArray.append([])
	
	if oldLesser.getGreat() == 0:
		returnArray[0] = false
	else:
		returnArray[0] = true
		returnArray[1] = -up.cross(oldLesser.getNormal()).normalized()
	
	if newLesser.getGreat() == 0:
		returnArray[2] = false
	else:
		returnArray[2] = true
		returnArray[3] = up.cross(newLesser.getNormal()).normalized()
	
	return returnArray

func slice(a, start, stop):
	var rA = []
	for i in range(start, stop, 1):
		rA.append(a[i])
	return rA

# count is the column count reached, baseNetIndex is the base of the first considered column, primaryFragment 
# is True if the first ratio columns are considered and False if the final ratio-1 columns are considered, baseMotion 
# is the function by which the baseNetIndex is twice moved, netIndexMotion is the translation function for moving up a column
func addStraightRookColumns(rookColumns, count, baseNetIndex, primaryFragment, baseMotion, netIndexMotion):
	# if the fragment is primary
	if primaryFragment:
		# iterate for each column in fragment
		for i in range(ratio):
			# calculate column index
			var column = count+i
                
			# number of rows
			var rows = 2*(i+1)
                
			# copy baseNetIndex into netIndex
			var netIndex = baseNetIndex
                
			# append netIndex
			rookColumns[column].append(int(netIndex))
                
			# iterate up remainder of column
			for j in range(rows-1):
				# calculate next netIndex
				netIndex = moveOnNet(netIndex, netIndexMotion)
                    
				# append netIndex
				rookColumns[column].append(int(netIndex))
                
			# break if final iteration
			if i == ratio-1:
				break
                
			# move baseNetIndex
			for j in range(2):
				baseNetIndex = moveOnNet(baseNetIndex, baseMotion)
            
		# account for iterations in count
		count += ratio
        
	# fragment is secondary
	else:
		# iterate for each column in fragment
		for i in range(ratio):
			# move baseNetIndex
			for j in range(2):
				baseNetIndex = moveOnNet(baseNetIndex, baseMotion)
                    
			# break if final iteration
			if i == ratio-1:
				break
                
			# calculate column index
			var column = count+i
                
			# num rows
			var rows = 2*(self.ratio-1-i)
                
			# set first netIndex
			var netIndex = baseNetIndex
                
			# append first netIndex
			rookColumns[column].append(int(netIndex))
                
			# iterate up remainder of column
			for j in range(rows-1):
				# calculate next netIndex
				netIndex = moveOnNet(netIndex, netIndexMotion)
                    
				# append next netIndex
				rookColumns[column].append(int(netIndex))
            
		# account for iterations in count
		count += self.ratio-1
	
	var returnValue = []
	returnValue.append(rookColumns)
	returnValue.append(count)
	returnValue.append(baseNetIndex)   
        
	# return relevant values
	return returnValue

# populate the rook notation list
func populateRookNotation():
	rookRows = []
	rookColumns = []
	# initialise empty rookRows list
	for i in range(ratio):
		rookRows.append([])
	
	# iterate through rows
	for i in range(ratio):
		var nc = 2*i+1
		# first netIndex in great B/1
		var netIndex = 2*i
            
		# append first netIndex
		rookRows[i].append(netIndex)
            
		# iterate along columns in great B/1
		for j in range(nc-1):
			# calculate next netIndex
			netIndex = moveAlphaDownLeft(netIndex)
			
			# append next netIndex
			rookRows[i].append(netIndex)
            
		# first netIndex in great C/2
		netIndex = leftmosts[2*self.ratio-1-i]
           
		# append first netIndex
		rookRows[i].append(netIndex)
		    
		# iterate along columns in great C/2
		for j in range(nc-1):
			# calculate next netIndex
			netIndex = moveRight(netIndex)
			     
			# append next netIndex
			rookRows[i].append(netIndex)
		
		# first netIndex in great D/3
		netIndex = rightmosts[i]
		
		# append first netIndex
		rookRows[i].append(netIndex)
		
		# iterate along columns in great D/3
		for j in range(nc-1):
			# calculate next netIndex
			netIndex = moveAlphaUpLeft(netIndex)
			
			# append next netIndex
			rookRows[i].append(netIndex)
	
	# no of rookColumns corresponding to one non-central great
	var nrc = 2*ratio-1
        
	# intialize empty columns
	for i in range(3*nrc):
		rookColumns.append([])
        
	# columns running count
	var count = 0
	
	# iterate columns of face B/1        
	# base netIndex
	var baseNetIndex = nrc-1
        
	# primary fragment
	var returnArray = addStraightRookColumns(rookColumns, count, baseNetIndex, true, "left", "betaDownRight")
        
	# secondary fragment
	returnArray = addStraightRookColumns(returnArray[0], returnArray[1], returnArray[2], false, "alphaDownRight", "betaDownRight")	
	    
	# face C/2
	# primary fragment
	returnArray = addStraightRookColumns(returnArray[0], returnArray[1], returnArray[2], true, "alphaDownRight", "up") 
	
	# secondary fragment
	returnArray = addStraightRookColumns(returnArray[0], returnArray[1], returnArray[2], false, "alphaUpRight", "up")
	
	# face D/3
	# primary fragment
	returnArray = addStraightRookColumns(returnArray[0], returnArray[1], returnArray[2], true, "alphaUpRight", "betaDownLeft")
        
	# secondary fragment
	returnArray = addStraightRookColumns(returnArray[0], returnArray[1], returnArray[2], false, "left", "betaDownLeft")
		
	rookColumns = returnArray[0]


func getOccupiedRookLines(netIndex):
	# set empty occupiedRookLines
	var occupiedRookLines = []
	 
	# iterate through rows
	for row in rookRows:
		# if netIndex present
		if netIndex in row:
			# append row with 'row' flag
			occupiedRookLines.append([row, true])
        
	# iterate through columns
	for column in rookColumns:
		# if netIndex present
		if netIndex in column:
			# append column with no 'row' flag
			occupiedRookLines.append([column, false])
	
	# return occupiedRookLines
	return occupiedRookLines

# list of moves, each move has it's netIndex and a bool that is True if it represents a capture, and False if it does not
func getRookMoves(armyIndex, netIndex):
	# is returning current position as valid move, WRONG!
	# get list of rows+columns in which rook is
	var occupiedRookLines = getOccupiedRookLines(netIndex)
	
	# initalize empty moves list
	var moves = []
	
	# iterate through rows+columns
	for pair in occupiedRookLines:
		# get content
		var line = pair[0]
		
		# get index of netIndex
		var index = line.find(netIndex)
		
		# if pre-netIndex indexes
		if index != 0:
			# slice copied line before index and reverse
			var formattedLine = slice(line, 0, index)
			formattedLine.invert()
			
			# if post-netIndex indexes exist and is row, consider circumnavigation
			if index != len(line)-1 and pair[1]:
				# slice copied line after index and reverse
				var addLine = slice(line, index+1, len(line))
				addLine.invert()
				
				# join two lines
				formattedLine += addLine
			
			# scan for moves
			moves = scanForRookMoves(armyIndex, formattedLine, moves)
			
		# if post-netIndex indexes
		if index != len(line)-1:
			# slice copied line after index
			var formattedLine = slice(line, index+1, len(line))

			# if pre-netIndex indexes exist and is row, consider circumnavigation
			if index != 0 and pair[1]:
				# slice copied line before index
				var addLine = slice(line, 0, index)
				
				# join two lines
				formattedLine += addLine
			
			# scan for moves
			moves = scanForRookMoves(armyIndex, formattedLine, moves)
	
	# return moves
	return moves

func getPawnMoves(armyIndex, netIndex):
	var moves = []
	
	for move in edgeMoves[netIndex]:
		if emptyNetIndex(move):
			moves.append([move, false])
	
	for move in vertexMoves[netIndex]:
		if hostilePieceInNetIndex(armyIndex, netIndex):
			moves.append([move, true])
	
	return moves

func getFersMoves(armyIndex, netIndex):
	var moves = []
	
	for move in vertexMoves[netIndex]:
		if emptyNetIndex(move):
			moves.append([move, false])
	
	for move in edgeMoves[netIndex]:
		if hostilePieceInNetIndex(armyIndex, netIndex):
			moves.append([move, true])
	
	return moves

func getKnightMoves(armyIndex, netIndex):
	var moves = []
	
	var firstSteps = vertexMoves[netIndex]
	
	for firstStep in firstSteps:
		var secondSteps = edgeMoves[firstStep]
		
		for secondStep in secondSteps:
			if emptyNetIndex(secondStep):
				moves.append([secondStep, false])
			elif hostilePieceInNetIndex(armyIndex, secondStep):
				moves.append([secondStep, true])
	
	return moves

func getCrownMoves(armyIndex, netIndex):
	var moves = []
	
	for move in edgeMoves[netIndex]:
		if emptyNetIndex(move):
			moves.append([move, false])
		elif hostilePieceInNetIndex(armyIndex, move):
			moves.append([move, true])
	
	for move in vertexMoves[netIndex]:
		if emptyNetIndex(move):
			moves.append([move, false])
		elif hostilePieceInNetIndex(armyIndex, move):
			moves.append([move, true])
	
	return moves

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func setup(argRatio, argPieces, argBoard):
	board = argBoard
	ratio = argRatio
	pieces = argPieces
	nl = int(pow(ratio, 2))
	
	populateLeftmosts()
	populateRightmosts()
	populateRookNotation()
	populateEdgeMoves()
	populateVertexMoves()