extends MeshInstance

const r3 = sqrt(3)
const r2 = sqrt(2)

var line_color = Color(0.1, 0.1, 0.1)
var capture_color = Color(1.0, 1.0, 0.0, 1.0)
var normal_move_color = Color(0.0, 1.0, 0.0, 1.0)
var current_net_index_color = Color(1.0, 0.5, 0.0, 1.0)

var vertices = []
var edges = []
var lessers = []

var ratio
var s

# list of lessermeshes, materials and collision shapes
var lesser_bodies = []

# conversion arrays
var net_to_lesser = []
var lesser_to_net = []

# number vars, per GREAT NOT BOARD
var nv
var ne
var nl

var ABC = Vector3(-0.5, 1.0/(2.0*r2*r3), r3/6.0)
var ACD = Vector3(0.5, 1.0/(2.0*r2*r3), r3/6.0)
var ADB = Vector3(0.0, 1.0/(2*r2*r3), -1.0/r3)
var bp = Vector3(0.0, -r2*r3/4.0, 0.0)

var ABCb = ABC-bp
var ACDb = ACD-bp
var ADBb = ADB-bp

var normals = []

func populate_vertices():
	var t = 2.0*PI/3.0
	
	var rotB = Transform()
	rotB = rotB.rotated(ABC.normalized(), t)
	rotB = rotB.rotated(normals[1], t)
	
	var rotC = Transform()
	rotC = rotC.rotated(ACD.normalized(), t)
	rotC = rotC.rotated(normals[2], t)
	
	var rotD = Transform()
	rotD = rotD.rotated(ADB.normalized(), t)
	rotD = rotD.rotated(normals[3], t)
	
	var temp_v = [[], [], [], []]
	
	var ll = s / float(ratio)
	
	var fp = s * ABC
	
	# iterate bottom to top
	for i in range(ratio+1):
		# calculate leftmost vertex of row i
		var br = fp + Vector3(float(i)*ll/2.0, 0.0, -float(i)*ll*r3/2.0)
		
		# iterate left to right
		for j in range(ratio+1-i):
			# face A
			# calculate vertex
			var vA = br + Vector3(float(j)*ll, 0.0, 0.0)
			temp_v[0].append(vA)
			
			# face B 
			temp_v[1].append(rotB * vA)

			# face C
			temp_v[2].append(rotC * vA)
			
			# face D
			temp_v[3].append(rotD * vA)
	
	for great in temp_v:
		for vertex in great:
			vertices.append(vertex)

func populate_edges():
	# iterate 'ratio' times 
	for i in range(ratio):
		# / lines or up right
		# HINT! Think in terms of arithmetic progressions
		# first vertex on face A
		var fvr = i
		# second vertex on face A
		var svr = int(((ratio+1)*(ratio+2)-pow(i,2)-i)/2)-1
		# append edge on each face to edges
		for j in range(4):
			edges.append([fvr+nv*j, svr+nv*j])
		
		# __ lines or horizontal
		# HINT! Think in terms of quadratic progressions
		# first vertex
		var fvh = int(i*(2*ratio+3-i)/2)
        
		# second vertex
		var svh = ratio + (ratio+1)*i-int(i*(i+1)/2)

		# append edges to list
		for j in range(4):
			edges.append([fvh+nv*j, svh+nv*j])

		# \ lines or up left
		# first vertex
		var fvl = i+1

		# second vertex
		var svl = (ratio+1)*(i+1)-int(i*(i+1)/2)

		# append edges to list
		for j in range(4):
			edges.append([fvl+nv*j, svl+nv*j])

func populate_net_to_lesser():
	# iterate through rows in top three great triangles of net
	for i in range(ratio):
		# iterate through columns of top left great triangle of net
		for j in range(2*(ratio-i)-1):
			# add specified triangle index to  conversion array
			net_to_lesser.append(pow(ratio, 2)+2*ratio-2+2*(ratio-1)*i-pow(i,2)-j)
           
		# iterate through columns of centre great triangle of net
		for j in range(2*i+1):
			# add specified triangle index to  conversion array
			net_to_lesser.append(pow(ratio,2)-1-pow(i,2)-2*i+j)
           
		# iterate through columns of top right great triangle of net
		for j in range(2*(ratio-i)-1):
			# add specified triangle index to  conversion array
			net_to_lesser.append(3*pow(ratio,2)+2*ratio-2+2*(ratio-1)*i-pow(i,2)-j)
            
	# iterate through rows in bottom great triangle of net
	for i in range(ratio):
		# iterate through columns in bottom great triangle of net
		for j in range(2*(ratio-i)-1):
			# add specified triangle index to  conversion array
			net_to_lesser.append(2*pow(ratio,2)+2*ratio-2+2*(ratio-1)*i-pow(i,2)-j)

func populate_lesser_to_net():
	for i in range(len(net_to_lesser)):
		lesser_to_net.append(-1)
	
	for i in range(len(net_to_lesser)):
		lesser_to_net[net_to_lesser[i]] = i;

func add_lists(list1, list2):
	var list3 = []
	for i in range(len(list1)):
		list3.append(list1[i]+list2[i])
	return list3

func populate_lessers():
	# number of up triangles per face
	var nu = int(ratio*(ratio+1)/2)
        
	# number of down triangles per face
	var nd = int(ratio*(ratio-1)/2)
        
	# initialize empty lessers list (in lesser notation)
	var lesser_lessers = []

	# initialize list of 4 empty lists for temp faces
	var temps = [[],[],[],[]]
        
 	# iterate for each face
	for i in range(4):
		# initialize list of 2 empty lists for up and down triangles
		var templ = [[],[]]
            
		# array to be added for each face
		var ai = [nv*i, nv*i, nv*i]
            
		# iterate ratio 'times' for up /\ triangles
		for j in range(ratio):
			# first coordinate of aj
			var c0 = int(j*(2*ratio+3-j)/2)
                
			# second coordinate of aj
			var c1 = c0+1
                
			# third coordinate of aj
			var c2 = ratio+1+int(j*(2*ratio+1-j)/2)
                
			# make aj array
			var aj = [c0,c1,c2]
                
			# iterate through steps traversed rightwards
			for k in range(ratio-j):
				# list to be added for each step traversed
				var ak = [k,k,k]
                    
				# sum arrays
				var lesser = add_lists(add_lists(aj, ak), ai)
                    
				# append triangle to relevant temp
				templ[0].append(lesser)
               
		# iterate ratio-1 'times' for down \/ triangles
		for j in range(ratio-1):
			# first coordinate of aj
			var c0 = 1+int(j*(2*ratio+3-j)/2)
                
			# second coordinate of aj
			var c1 = ratio+2+int(j*(2*ratio+1-j)/2)
                
			# third coordinate of aj
			var c2 = c1-1

			# make aj array
			var aj = [c0,c1,c2]
                
			# iterate through steps traversed rightwards
			for k in range(ratio-1-j):
				# list to be added for each step traversed
				var ak = [k,k,k]
                    
				# sum lists
				var lesser = add_lists(add_lists(aj, ak), ai)
                    
				# append triangle to relevant temp
				templ[1].append(lesser)
            
		# move up great triangle from base
		for j in range(ratio):
			# move along 'rows' of great triangle
			for k in range(2*ratio-1-2*j):
				# if steps taken is even
				var lesser
				if k % 2 == 0:
					# pop 'up' /\ lesser from start
					lesser = templ[0][0]
					templ[0].pop_front()
				else:
					# pop 'down' \/ lesser from start
					lesser = templ[1][0]
					templ[1].pop_front()
				
				# append lesser to relevant great face
				temps[i].append(lesser)
                    
	# add each lesser to lesser_lessers in correct order
	for great in temps:
		for lesser in great:
			lesser_lessers.append(lesser)
        
	# set lessers as nl*4 length list of 0's
	lessers = []
	for i in range(4*nl):
		lessers.append(-1)
        
	# enumerate through lesserTriangles
	for i in range(4*nl):
		# calculate net_index
		var net_index = lesser_to_net[i]
		      
		# swap coordinates
		lessers[net_index] = lesser_lessers[i]

func get_great(net_index):
	var lesser_index = net_to_lesser[net_index]
	if lesser_index < nl:
		return 0
	if lesser_index < 2*nl:
		return 1
	if lesser_index < 3*nl:
		return 2
	return 3

func draw_board():
	var surface_tool_edge = SurfaceTool.new()
	surface_tool_edge.begin(Mesh.PRIMITIVE_LINES)
	surface_tool_edge.add_color(line_color)
	
	for i in range(4*ne):
		for j in range(2):
			var vertex = vertices[edges[i][j]]*1.005
			surface_tool_edge.add_vertex(vertex)
	
	var edge_mesh = surface_tool_edge.commit()
	self.mesh = edge_mesh
	
	var lesser_scene = load("res://scenes/lesser.tscn")
	
	for i in range(4*nl):
		var lesser_instance = lesser_scene.instance()
		lesser_instance.set_name("lesser_instance" + str(i))
		add_child(lesser_instance)
		var lesser_body = get_tree().get_nodes_in_group("lesser_bodies")[i]
		var great = get_great(i)
		var normal = normals[great]
		var lesser_vertices = []
		
		for j in range(3):
			lesser_vertices.append(vertices[lessers[i][2-j]])
		
		lesser_body.setup(great, i, normal, lesser_vertices)

func _ready():
	pass

func setup(arg_ratio, arg_s):
	ratio = arg_ratio
	s = arg_s
	create_board()

func reset_colors():
	for lesser_body in lesser_bodies:
		lesser_body.reset_color()

func color_moves(current_net_index, moves):
	lesser_bodies[current_net_index].set_color(current_net_index_color)
	
	for move in moves:
		if move[1]:
			lesser_bodies[move[0]].set_color(capture_color)
		else:
			lesser_bodies[move[0]].set_color(normal_move_color)

func populate_lights():
	var light_scene = load("res://scenes/Light.tscn")
	for i in range(4):
		var light_instance = light_scene.instance()
		light_instance.set_name("Light" + str(i))
		light_instance.setup(normals[i] * 2)
		add_child(light_instance)

func create_board():
	normals.append(Vector3(0,1,0))
	var nB = ABCb.cross(ADBb)
	normals.append(nB.normalized())
	var nC = ACDb.cross(ABCb)
	normals.append(nC.normalized())
	var nD = ADBb.cross(ACDb)
	normals.append(nD.normalized())
	nl = int(pow(ratio, 2))
	nv = int(ratio*(ratio+3)/2)+1
	ne = 3*ratio
	populate_vertices()
	populate_edges()
	populate_net_to_lesser()
	populate_lesser_to_net()
	populate_lessers()
	populate_lights()
	draw_board()
	lesser_bodies = get_tree().get_nodes_in_group("lesser_bodies")