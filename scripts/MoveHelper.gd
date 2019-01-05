extends Node

# left- and rightmost lessers of each NET row
var leftmosts = []
var rightmosts = []

var edge_moves = []
var vertex_moves = []

var rook_rows = []
var rook_columns = []

var ratio
var nl

var board

var pieces = []

# right-most value of a given net-row
func populate_rightmosts():
	for i in range(2*ratio):
		rightmosts.append((4*ratio-2)*(i+1)-int(pow(i,2)))
    
func scan_for_rook_moves(army_index, line, moves):
	# iterate through line
	for i_net_index in line:
		# if hostile piece in i_net_index
		if hostile_piece_in_net_index(army_index, i_net_index):
			# calculate move
			var move = [i_net_index, true]
			 
			# if move is not already in moves
			if not moves.has(move):
				# append move to moves
				moves.append(move)
                       
			# end of chain, break
			break
		elif friendly_piece_in_net_index(army_index, i_net_index):
			# end of chain, break
			break
		else:
			# calculate move
			var move = [i_net_index, false]
                
			# if move is not already in moves
			if not moves.has(move):
				# append move to moves
				moves.append(move)
				   
	# return moves
	return moves

# left-most value of a given net-row
func populate_leftmosts():
	for i in range(2*ratio):
		leftmosts.append((4*ratio-i)*i)

func hostile_piece_in_net_index(army_index, net_index):
	# iterate through pieces
	
	var piece = pieces[net_index]
	
	if piece.empty():
		return false
	
	if army_index != piece[0].get_army_index():
		return true
	
	return false

func friendly_piece_in_net_index(army_index, net_index):
	var piece = pieces[net_index]
	
	if piece.empty():
		return false
	
	if army_index == piece[0].get_army_index():
		return true
	
	return false
	
func empty_net_index(net_index):
	var piece_array = pieces[net_index]
	
	if piece_array.empty():
		return true
	
	return false

func get_net_row(net_index):
	# iterate through each row (no rows = ratio*2)
	for i in range(ratio*2):
		# if net_index is leq to index of rightmost lesser of row i
		if net_index <= rightmosts[i]:
			# return row number
			return i

# returns True if triangle is up /\, False if it is down \/
func is_up(net_index):
	# get row of net_index
	var net_row = get_net_row(net_index)
	
	# get leftmost of net_row
	var leftmost = leftmosts[net_row]
	
	# every leftmost is a down triangle
	# if an odd number of triangles along from leftmost
	if int(net_index-leftmost) % 2 == 1:
		# triangle is up
		return true
            
	# it is even, and hence triangle is down
	return false

# move alpha in direction down left / on NET
func move_alpha_down_left(net_index):
	# if triangle is down
	if not is_up(net_index):
		# return decremented net_index
		return net_index-1
        
	# hence triangle is up
	# get net row
	var net_row = get_net_row(net_index)
        
	# get leftmost
	var leftmost = leftmosts[net_row]
        
	# get leftmost of row below
	var leftmost_below = leftmosts[net_row+1]
        
	# calculate displacement from leftmost
	var d = net_index-leftmost
        
	# return the leftmost_below summed with (d-1)
	return leftmost_below + d-1

# move alpha up right / on NET
func move_alpha_up_right(net_index):
	# if triangle is up
	if is_up(net_index):
		# return incremented net_index
		return net_index+1
       
	# hence triangle is down
	# get net row
	var net_row = get_net_row(net_index)
       
	# get left-most
	var leftmost = leftmosts[net_row]
       
	# get leftmost of row above
	var leftmost_above = leftmosts[net_row-1]
       
	# calculate displacement from leftmost
	var d = net_index-leftmost

	# return leftmost_below added to (d+1)
	return leftmost_above + (d+1)

# move in direction <- on NET
func moveLeft(net_index):
	return net_index-1
    
# move in direction -> on NET
func moveRight(net_index):
	return net_index+1

# move in direction ^ on NET
func move_up(net_index):
	# calculate net_row
	var net_row = get_net_row(net_index)
        
	# calculate leftmost
	var leftmost = leftmosts[net_row]
        
	# calculate leftmost of row above
	var leftmost_above = leftmosts[net_row-1]
        
	# calculate distance from leftmost
	var d = net_index - leftmost
        
	# return leftmost_above + (d+1)
	return leftmost_above + (d+1)

# move in direction v on net
func move_down(net_index):
	# calculate net_row
	var net_row = get_net_row(net_index)
        
	# calculate leftmost
	var leftmost = leftmosts[net_row]
        
	# calculate leftmost of row below
	var leftmost_below = leftmosts[net_row+1]
        
	# calculate distance from leftmost
	var d = net_index - leftmost
        
	# return leftmost_below + (d-1)
	return leftmost_below + (d-1)

# move alpha down right \ on NET
func move_alpha_down_right(net_index):
	# if triangle is down
	if not is_up(net_index):
		# return incremented net_index
		return net_index+1
        
	# hence triangle is up
	# get net row
	var net_row = get_net_row(net_index)
        
	# get right-most
	var rightmost = rightmosts[net_row]
        
	# get right-most of row below
	var rightmost_below = rightmosts[net_row+1]
        
	# calculate distance from right-most
	var d = rightmost-net_index
        
	# return rightmost_below - (d-1)
	return rightmost_below - (d-1)

# move alpha up left \ on NET
func move_alpha_up_left(net_index):
	# if triangle is up
	if is_up(net_index):
		# return decremented net_index
		return net_index-1
        
	# hence triangle is down
	# get net row
	var net_row = get_net_row(net_index)
        
	# get right-most
	var rightmost = rightmosts[net_row]
        
	# get right-most of row below
	var rightmost_above = rightmosts[net_row-1]
        
	# calculate distance from right-most
	var d = rightmost-net_index
        
	# return rightmost_below - (d+1)
	return rightmost_above - (d+1)

# move beta down left / on NET
func move_beta_down_left(net_index):
	# if triangle is down
	if not is_up(net_index):
		# return decremented net_index
		return net_index-1
        
	# hence triangle is up
	# calculate net_row
	var net_row = get_net_row(net_index)
        
	# calculate rightmost of net_row
	var rightmost = rightmosts[net_row]
        
	# calculate rightmost of below net_row
	var rightmost_below = rightmosts[net_row+1]
        
	# calculate distance from rightmost
	var d = rightmost-net_index
        
	# return rightmost_below with (d+1) subtracted
	return rightmost_below - (d+1)

# move beta up right / on NET
func move_beta_up_right(net_index):
	# if triangle is up
	if is_up(net_index):
		# return incremented net_index
		return net_index+1
        
	# hence triangle is down
	# calculate net_row
	var net_row = get_net_row(net_index)
        
	# calculate rightmost of net_row
	var rightmost = rightmosts[net_row]
        
	# calculate rightmost of above net_row
	var rightmost_above = rightmosts[net_row-1]
        
	# calculate distance from rightmost
	var d = rightmost-net_index
        
	# return rightmost_above with (d-1) subtracted
	return rightmost_above - (d-1)

# move beta down right \ on NET
func move_beta_down_right(net_index):
	# if triangle is down
	if not is_up(net_index):
		# return incremented net_index
		return net_index+1
        
	# hence triangle is up
	# calculate net_row
	var net_row = get_net_row(net_index)
        
	# calculate leftmost of net_row
	var leftmost = leftmosts[net_row]
        
	# calculate leftmost of below net_row
	var leftmost_below = leftmosts[net_row+1]
        
	# calculate distance from leftmost
	var d = net_index-leftmost
        
	# return leftmost_below with (d+1) added
	return leftmost_below + d+1

# move beta up left \ on NET
func move_beta_up_left(net_index):
	# if triangle is up
	if is_up(net_index):
		# return decremented net_index
		return net_index-1
        
	# hence triangle is down
	# calculate net_row
	var net_row = get_net_row(net_index)
        
	# calculate leftmost of net_row
	var leftmost = leftmosts[net_row]
        
	# calculate leftmost of above net_row
	var leftmost_above = leftmosts[net_row-1]
        
	# calculate distance from leftmost
	var d = net_index-leftmost
        
	# return leftmost_above with (d-1) added
	return leftmost_above + d-1

func move_on_net(net_index, motion):
	match motion:
		"left":
			net_index = moveLeft(net_index)
		"right":
			net_index = moveRight(net_index)
		"up":
			net_index = move_up(net_index)
		"down":
			net_index = move_down(net_index)
		"alphaDownLeft": 
			net_index = move_alpha_down_left(net_index) 
		"alphaDownRight":
			net_index = move_alpha_down_right(net_index)
		"alphaUpLeft":
			net_index = move_alpha_up_left(net_index)
		"alphaUpRight":
			net_index = move_alpha_up_right(net_index)
		"betaUpLeft":
			net_index = move_beta_up_left(net_index)
		"betaUpRight":
			net_index = move_beta_up_right(net_index)
		"betaDownLeft":
			net_index = move_beta_down_left(net_index)
		"betaDownRight":
			net_index = move_beta_down_right(net_index)
	
	return net_index

func populate_edge_moves():
	edge_moves = []
	
	for i in range(4*nl):
		edge_moves.append([])
	
	for i in range(4*nl):
		# if up triangle
		if is_up(i):
			# trivial motion
			edge_moves[i].append(move_alpha_up_left(i))
			edge_moves[i].append(move_down(i))
			edge_moves[i].append(move_alpha_up_right(i))
		else:
			# non-trivial motion
			var great = board.get_great(i)
			
			# alpha down left motion
			# if leftmost net_index
			if leftmosts.has(i):
				var row = get_net_row(i)
				var nextRow = 2*ratio - row - 1
				edge_moves[i].append(leftmosts[nextRow])
			# not leftmost net_index
			else:
				edge_moves[i].append(move_alpha_down_left(i))
			
			# alpha down right motion
			# if rightmost net_index
			if rightmosts.has(i):
				var row = get_net_row(i)
				var nextRow = 2*ratio - row -1
				edge_moves[i].append(rightmosts[nextRow])
			# not rightmost net_index
			else:
				edge_moves[i].append(move_alpha_down_right(i))
			
			# up motion
			# if net_index in top row
			if get_net_row(i) == 0:
				edge_moves[i].append(4*ratio - 2 - i)
			# not in top row
			else:
				edge_moves[i].append(move_up(i))

func populate_vertex_moves():
	vertex_moves = []
	for i in range(4*nl):
		vertex_moves.append([])
	
	# iterate through lessers
	for i in range(4*nl):
		# if up
		if is_up(i):
			# moving up
			# if not illegal position
			if i != 2*ratio-1:
				# if top most
				if get_net_row(i) == 0:
					vertex_moves[i].append(4*ratio-2-i)
				# not top most
				else:
					vertex_moves[i].append(move_up(i))
			
			# moving beta down right
			# if not illegal position
			if i != rightmosts[ratio-1]-1:
				# if one less than rightmost
				if rightmosts.has(i+1):
					var row = get_net_row(i)
					var nextRow = 2*ratio-row-2
					vertex_moves[i].append(rightmosts[nextRow]-1)
				# not one less than rightmost
				else:
					vertex_moves[i].append(move_beta_down_right(i))
			
			# moving beta down left
			# if not illegal position
			if i != leftmosts[ratio-1]+1:
				# if one more than leftmost
				if leftmosts.has(i-1):
					var row = get_net_row(i)
					var nextRow = 2*ratio-row-2
					vertex_moves[i].append(leftmosts[nextRow]+1)
				# not one more than leftmost
				else:
					vertex_moves[i].append(move_beta_down_left(i))
		# is down
		else:
			# moving down
			# if not illegal position
			if i != 4*nl-1 and i != leftmosts[ratio-1] and i != rightmosts[ratio-1]:
				# if in leftmosts
				
				if leftmosts.has(i):
					var row = get_net_row(i)
					var nextRow = 2*ratio-row-2
					vertex_moves[i].append(leftmosts[nextRow])
				# else if in rightmosts
				elif rightmosts.has(i):
					var row = get_net_row(i)
					var nextRow = 2*ratio-row-2
					vertex_moves[i].append(rightmosts[nextRow])
				else:
					vertex_moves[i].append(move_down(i))
			
			# moving beta up right
			# if not illegal position
			if i != 4*ratio-2 and i != 2*ratio-2 and i != rightmosts[ratio]:
				# if in rightmosts
				if rightmosts.has(i):
					var row = get_net_row(i)
					var nextRow = 2*ratio-row
					vertex_moves[i].append(rightmosts[nextRow])
				# else if top row
				elif get_net_row(i) == 0:
					vertex_moves[i].append(4*ratio-4-i)
				else:
					vertex_moves[i].append(move_beta_up_right(i))
			
			# moving beta up left
			# if not illegal position
			if i != 0 and i != 2*ratio and i != leftmosts[ratio]:
				# if i in leftmosts
				if leftmosts.has(i):
					var row = get_net_row(i)
					var nextRow = 2*ratio-row
					vertex_moves[i].append(leftmosts[nextRow])
				# else if top row
				elif get_net_row(i) == 0:
					vertex_moves[i].append(4*ratio-i)
				else:
					vertex_moves[i].append(move_beta_up_left(i))

func get_rotate(old_lesser, new_lesser):
	var return_array = []
	var up = Vector3(0, 1, 0)
	
	for i in range(4):
		return_array.append([])
	
	if old_lesser.get_great() == 0:
		return_array[0] = false
	else:
		return_array[0] = true
		return_array[1] = -up.cross(old_lesser.get_normal()).normalized()
	
	if new_lesser.get_great() == 0:
		return_array[2] = false
	else:
		return_array[2] = true
		return_array[3] = up.cross(new_lesser.get_normal()).normalized()
	
	return return_array

func slice(a, start, stop):
	var rA = []
	for i in range(start, stop, 1):
		rA.append(a[i])
	return rA

# count is the column count reached,base_net_index is the base of the first considered column, primary_fragment 
# is True if the first ratio columns are considered and False if the final ratio-1 columns are considered, base_motion 
# is the function by which thebase_net_index is twice moved, net_index_motion is the translation function for moving up a column
func add_straight_rook_columns(rook_columns, count,base_net_index, primary_fragment, base_motion, net_index_motion):
	# if the fragment is primary
	if primary_fragment:
		# iterate for each column in fragment
		for i in range(ratio):
			# calculate column index
			var column = count+i
                
			# number of rows
			var rows = 2*(i+1)
                
			# copybase_net_index into net_index
			var net_index = base_net_index
                
			# append net_index
			rook_columns[column].append(int(net_index))
                
			# iterate up remainder of column
			for j in range(rows-1):
				# calculate next net_index
				net_index = move_on_net(net_index, net_index_motion)
                    
				# append net_index
				rook_columns[column].append(int(net_index))
                
			# break if final iteration
			if i == ratio-1:
				break
                
			# movebase_net_index
			for j in range(2):
				base_net_index = move_on_net(base_net_index, base_motion)
            
		# account for iterations in count
		count += ratio
        
	# fragment is secondary
	else:
		# iterate for each column in fragment
		for i in range(ratio):
			# movebase_net_index
			for j in range(2):
				base_net_index = move_on_net(base_net_index, base_motion)
                    
			# break if final iteration
			if i == ratio-1:
				break
                
			# calculate column index
			var column = count+i
                
			# num rows
			var rows = 2*(self.ratio-1-i)
                
			# set first net_index
			var net_index = base_net_index
                
			# append first net_index
			rook_columns[column].append(int(net_index))
                
			# iterate up remainder of column
			for j in range(rows-1):
				# calculate next net_index
				net_index = move_on_net(net_index, net_index_motion)
                    
				# append next net_index
				rook_columns[column].append(int(net_index))
            
		# account for iterations in count
		count += self.ratio-1
	
	var return_value = []
	return_value.append(rook_columns)
	return_value.append(count)
	return_value.append(base_net_index)   
        
	# return relevant values
	return return_value

# populate the rook notation list
func populate_rook_notation():
	rook_rows = []
	rook_columns = []
	# initialise empty rook_rows list
	for i in range(ratio):
		rook_rows.append([])
	
	# iterate through rows
	for i in range(ratio):
		var nc = 2*i+1
		# first net_index in great B/1
		var net_index = 2*i
            
		# append first net_index
		rook_rows[i].append(net_index)
            
		# iterate along columns in great B/1
		for j in range(nc-1):
			# calculate next net_index
			net_index = move_alpha_down_left(net_index)
			
			# append next net_index
			rook_rows[i].append(net_index)
            
		# first net_index in great C/2
		net_index = leftmosts[2*self.ratio-1-i]
           
		# append first net_index
		rook_rows[i].append(net_index)
		    
		# iterate along columns in great C/2
		for j in range(nc-1):
			# calculate next net_index
			net_index = moveRight(net_index)
			     
			# append next net_index
			rook_rows[i].append(net_index)
		
		# first net_index in great D/3
		net_index = rightmosts[i]
		
		# append first net_index
		rook_rows[i].append(net_index)
		
		# iterate along columns in great D/3
		for j in range(nc-1):
			# calculate next net_index
			net_index = move_alpha_up_left(net_index)
			
			# append next net_index
			rook_rows[i].append(net_index)
	
	# no of rook_columns corresponding to one non-central great
	var nrc = 2*ratio-1
        
	# intialize empty columns
	for i in range(3*nrc):
		rook_columns.append([])
        
	# columns running count
	var count = 0
	
	# iterate columns of face B/1        
	# base net_index
	var base_net_index = nrc-1
        
	# primary fragment
	var return_array = add_straight_rook_columns(rook_columns, count,base_net_index, true, "left", "betaDownRight")
        
	# secondary fragment
	return_array = add_straight_rook_columns(return_array[0], return_array[1], return_array[2], false, "alphaDownRight", "betaDownRight")	
	    
	# face C/2
	# primary fragment
	return_array = add_straight_rook_columns(return_array[0], return_array[1], return_array[2], true, "alphaDownRight", "up") 
	
	# secondary fragment
	return_array = add_straight_rook_columns(return_array[0], return_array[1], return_array[2], false, "alphaUpRight", "up")
	
	# face D/3
	# primary fragment
	return_array = add_straight_rook_columns(return_array[0], return_array[1], return_array[2], true, "alphaUpRight", "betaDownLeft")
        
	# secondary fragment
	return_array = add_straight_rook_columns(return_array[0], return_array[1], return_array[2], false, "left", "betaDownLeft")
		
	rook_columns = return_array[0]


func get_occupied_rook_lines(net_index):
	# set empty occupied_rook_lines
	var occupied_rook_lines = []
	 
	# iterate through rows
	for row in rook_rows:
		# if net_index present
		if net_index in row:
			# append row with 'row' flag
			occupied_rook_lines.append([row, true])
        
	# iterate through columns
	for column in rook_columns:
		# if net_index present
		if net_index in column:
			# append column with no 'row' flag
			occupied_rook_lines.append([column, false])
	
	# return occupied_rook_lines
	return occupied_rook_lines

# list of moves, each move has it's net_index and a bool that is True if it represents a capture, and False if it does not
func get_rook_moves(army_index, net_index):
	# is returning current position as valid move, WRONG!
	# get list of rows+columns in which rook is
	var occupied_rook_lines = get_occupied_rook_lines(net_index)
	
	# initalize empty moves list
	var moves = []
	
	# iterate through rows+columns
	for pair in occupied_rook_lines:
		# get content
		var line = pair[0]
		
		# get index of net_index
		var index = line.find(net_index)
		
		# if pre-net_index indexes
		if index != 0:
			# slice copied line before index and reverse
			var formattedLine = slice(line, 0, index)
			formattedLine.invert()
			
			# if post-net_index indexes exist and is row, consider circumnavigation
			if index != len(line)-1 and pair[1]:
				# slice copied line after index and reverse
				var addLine = slice(line, index+1, len(line))
				addLine.invert()
				
				# join two lines
				formattedLine += addLine
			
			# scan for moves
			moves = scan_for_rook_moves(army_index, formattedLine, moves)
			
		# if post-net_index indexes
		if index != len(line)-1:
			# slice copied line after index
			var formattedLine = slice(line, index+1, len(line))

			# if pre-net_index indexes exist and is row, consider circumnavigation
			if index != 0 and pair[1]:
				# slice copied line before index
				var addLine = slice(line, 0, index)
				
				# join two lines
				formattedLine += addLine
			
			# scan for moves
			moves = scan_for_rook_moves(army_index, formattedLine, moves)
	
	# return moves
	return moves

func get_pawn_moves(army_index, net_index):
	var moves = []
	
	for move in edge_moves[net_index]:
		if empty_net_index(move):
			moves.append([move, false])
	
	for move in vertex_moves[net_index]:
		if hostile_piece_in_net_index(army_index, move):
			moves.append([move, true])
	
	return moves

func get_fers_moves(army_index, net_index):
	var moves = []
	
	for move in vertex_moves[net_index]:
		if empty_net_index(move):
			moves.append([move, false])
	
	for move in edge_moves[net_index]:
		if hostile_piece_in_net_index(army_index, move):
			moves.append([move, true])
	
	return moves

func get_knight_moves(army_index, net_index):
	var moves = []
	
	var first_steps = vertex_moves[net_index]
	
	for first_step in first_steps:
		var second_steps = edge_moves[first_step]
		
		for second_step in second_steps:
			if empty_net_index(second_step):
				moves.append([second_step, false])
			elif hostile_piece_in_net_index(army_index, second_step):
				moves.append([second_step, true])
	
	return moves

func get_crown_moves(army_index, net_index):
	var moves = []
	
	for move in edge_moves[net_index]:
		if empty_net_index(move):
			moves.append([move, false])
		elif hostile_piece_in_net_index(army_index, move):
			moves.append([move, true])
	
	for move in vertex_moves[net_index]:
		if empty_net_index(move):
			moves.append([move, false])
		elif hostile_piece_in_net_index(army_index, move):
			moves.append([move, true])
	
	return moves

func get_moves(net_index):
	var piece = pieces[net_index][0]
	var moves
	var type = piece.get_type()
	var army_index = piece.get_army_index()
	match type:
		"rook":
			moves = get_rook_moves(army_index, net_index)
		"fers":
			moves = get_fers_moves(army_index, net_index)
		"crown":
			moves = get_crown_moves(army_index, net_index)
		"knight":
			moves = get_knight_moves(army_index, net_index)
		"pawn":
			moves = get_pawn_moves(army_index, net_index)
	
	return moves

func legal_move(first_net_index, second_net_index):
	var moves = get_moves(first_net_index)
	
	for move in moves:
		if second_net_index == move[0]:
			return true
			
	return false

func move(first_net_index, second_net_index):
	var piece = pieces[first_net_index][0]
	var army_index = piece.get_army_index()
	
	if hostile_piece_in_net_index(army_index, second_net_index):
		pieces[second_net_index][0].queue_free()
	
	piece.move(second_net_index)
	
	pieces[second_net_index] = [piece]
	pieces[first_net_index] = []

func get_pieces():
	return pieces

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func setup(arg_ratio, arg_pieces, arg_board):
	board = arg_board
	ratio = arg_ratio
	pieces = arg_pieces
	nl = int(pow(ratio, 2))
	
	populate_leftmosts()
	populate_rightmosts()
	populate_rook_notation()
	populate_edge_moves()
	populate_vertex_moves()