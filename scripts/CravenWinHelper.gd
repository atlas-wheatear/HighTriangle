extends Node

var move_helper
var no_players
var winner = -1
var values = {"pawn" : 1, "fers" : 1, "knight" : 3, "rook" : 5}

func update_winner():
	# initialise score and craven as empty array
	var scores = []
	var cravens = []
	
	# add a 0 to score and false to craven for each player
	for i in range(no_players):
		scores.append(0)
		cravens.append(false)
	
	# get pieces
	var pieces = move_helper.get_pieces()
	
	# iterate through pieces
	for piece_array in pieces:
		# if there is no piece in net_index
		if piece_array.empty():
			continue
		
		# get piece
		var piece = piece_array[0]
		
		# get piece's type
		var type = piece.get_type()
		
		# if the piece is a crown, continue
		if type == "crown":
			continue
		
		# get value of piece
		var value = values[type]
		
		# get net and army index
		var net_index = piece.get_net_index()
		var army_index = piece.get_army_index()
		
		# get moves
		var moves = move_helper.get_moves(net_index)
		
		# iterate through moves
		for move in moves:
			# if not capture, continue
			if not move[1]:
				continue
			
			# get attacked piece and its army index
			var attacked_piece = pieces[move[0]][0]
			var attacked_piece_army_index = attacked_piece.get_army_index()
			
			# if attacked piece is a hostile crown
			if attacked_piece.get_type() == "crown" and attacked_piece_army_index != army_index:
				# set the attacked piece's army as craven
				cravens[attacked_piece_army_index] = true
				
				# if piece value is higher than previously
				if value > scores[army_index]:
					# set new score
					scores[army_index] = value
	
	# set craven count as 0
	var craven_count = 0
	
	# iterate through cravens
	for craven in cravens:
		# if craven, increment craven_count
		if craven:
			craven_count += 1
	
	# if there are cravens
	if craven_count > 0:
		# if every player is a craven
		if craven_count == no_players:
			winner = no_players
		
		# otherwise determine winner
		else:
			# set player 1 as the high scorer
			var high_score = scores[0]
			winner = 0
			
			# iterate through players
			for i in range(1, no_players):
				var player_score = scores[i]
				
				# if equal, non-zero score
				if player_score > 0 and player_score == high_score:
					# no decisive winner, break
					winner = no_players
					break
				
				# if higher score
				if player_score > high_score:
					# new high score
					high_score = player_score
					winner = i

func game_over():
	# update winner variable
	update_winner()
	
	# if the game is over, return true
	if winner != -1:
		return true
	
	# no winner, return false
	return false

func decisive_winner():
	if winner == no_players:
		return false
	return true

func get_winner():
	return winner

func _ready():
	pass

func setup(arg_no_players, arg_move_helper):
	# set arguments as attributes
	no_players = arg_no_players
	move_helper = arg_move_helper