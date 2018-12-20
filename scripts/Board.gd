extends MeshInstance

const r3 = sqrt(3)
const r2 = sqrt(2)

var lineColor = Color(0.1, 0.1, 0.1)
var defaultLesserColor = Color(0.9, 0.9, 0.9, 1.0)

var s = 2.0
var vertices = []
var edges = []
var lessers = []

# list of lessermeshes, materials and collision shapes
var lesserBodies = []
var lesserMeshes = []
var lesserMeshesMaterials = []
var lesserMeshesCollisionShapes = []

# conversion arrays
var netToLesser = []
var lesserToNet = []

# number vars, per GREAT NOT BOARD
var nv
var ne
var nl
var ratio

var ABC = Vector3(-0.5, 1.0/(2.0*r2*r3), r3/6.0)
var ACD = Vector3(0.5, 1.0/(2.0*r2*r3), r3/6.0)
var ADB = Vector3(0.0, 1.0/(2*r2*r3), -1.0/r3)
var bp = Vector3(0.0, -r2*r3/4.0, 0.0)

var ABCb = ABC-bp
var ACDb = ACD-bp
var ADBb = ADB-bp

var normals = []

# remember definition of XYZ!!!

func populateVertices():
	
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
	
	var tempv = [[], [], [], []]
	
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
			tempv[0].append(vA)
			
			# face B 
			tempv[1].append(rotB * vA)

			# face C
			tempv[2].append(rotC * vA)
			
			# face D
			tempv[3].append(rotD * vA)
	
	for great in tempv:
		for vertex in great:
			vertices.append(vertex)

func populateEdges():
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

func populateNetToLesser():
	# iterate through rows in top three great triangles of net
	for i in range(ratio):
		# iterate through columns of top left great triangle of net
		for j in range(2*(ratio-i)-1):
			# add specified triangle index to  conversion array
			netToLesser.append(pow(ratio, 2)+2*ratio-2+2*(ratio-1)*i-pow(i,2)-j)
           
		# iterate through columns of centre great triangle of net
		for j in range(2*i+1):
			# add specified triangle index to  conversion array
			netToLesser.append(pow(ratio,2)-1-pow(i,2)-2*i+j)
           
		# iterate through columns of top right great triangle of net
		for j in range(2*(ratio-i)-1):
			# add specified triangle index to  conversion array
			netToLesser.append(3*pow(ratio,2)+2*ratio-2+2*(ratio-1)*i-pow(i,2)-j)
            
	# iterate through rows in bottom great triangle of net
	for i in range(ratio):
		# iterate through columns in bottom great triangle of net
		for j in range(2*(ratio-i)-1):
			# add specified triangle index to  conversion array
			netToLesser.append(2*pow(ratio,2)+2*ratio-2+2*(ratio-1)*i-pow(i,2)-j)

func populateLesserToNet():
	
	for i in range(len(netToLesser)):
		lesserToNet.append(-1)
	
	for i in range(len(netToLesser)):
		lesserToNet[netToLesser[i]] = i;

func addLists(list1, list2):
	var list3 = []
	for i in range(len(list1)):
		list3.append(list1[i]+list2[i])
	return list3

func populateLessers():
	# number of up triangles per face
	var nu = int(ratio*(ratio+1)/2)
        
	# number of down triangles per face
	var nd = int(ratio*(ratio-1)/2)
        
	# initialize empty lessers list (in lesser notation)
	var lesserLessers = []

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
				var lesser = addLists(addLists(aj, ak), ai)
                    
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
				var lesser = addLists(addLists(aj, ak), ai)
                    
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
                    
	# add each lesser to lesserLessers in correct order
	for great in temps:
		for lesser in great:
			lesserLessers.append(lesser)
        
	# set lessers as nl*4 length list of 0's
	lessers = []
	for i in range(4*nl):
		lessers.append(-1)
        
	# enumerate through lesserTriangles
	for i in range(4*nl):
		# calculate netIndex
		var netIndex = lesserToNet[i]
		      
		# swap coordinates
		lessers[netIndex] = lesserLessers[i]

func getGreat(netIndex):
	var lesserIndex = netToLesser[netIndex]
	if lesserIndex < nl:
		return 0
	if lesserIndex < 2*nl:
		return 1
	if lesserIndex < 3*nl:
		return 2
	return 3

func drawBoard():

	# list of lessermeshes and lessers' materials
	lesserMeshes = []
	lesserMeshesMaterials = []

	var surfaceToolEdge = SurfaceTool.new()
	surfaceToolEdge.begin(Mesh.PRIMITIVE_LINES)
	surfaceToolEdge.add_color(lineColor)
	
	for i in range(4*ne):
		for j in range(2):
			var vertex = vertices[edges[i][j]]*1.005
			surfaceToolEdge.add_vertex(vertex)
	
	var edgeMesh = surfaceToolEdge.commit()
	self.mesh = edgeMesh
	
	var lesserScene = load("res://scenes/lesser.tscn")
	
	for i in range(4*nl):
		var lesserInstance = lesserScene.instance()
		lesserInstance.set_name("lesserScene" + str(i))
		add_child(lesserInstance)
		var lesserBody = get_tree().get_nodes_in_group("lesserBodies")[i]
		var normal = normals[getGreat(i)]
		var lesserVertices = []
		
		for j in range(3):
			lesserVertices.append(vertices[lessers[i][2-j]])
		
		lesserBody.setup(i, normal, lesserVertices)

func _ready():
	ratio = 8
	createBoard()

func setColor(netIndex, newColor):
	pass

func createBoard():
	normals.append(Vector3(0,1,0))
	var nB = ABCb.cross(ADBb)
	normals.append(nB.normalized())
	var nC = ACDb.cross(ABCb)
	normals.append(nC.normalized())
	var nD = ADBb.cross(ACDb)
	normals.append(nD.normalized())
	nl = pow(ratio, 2)
	nv = int(ratio*(ratio+3)/2)+1
	ne = 3*ratio
	populateVertices()
	populateEdges()
	populateNetToLesser()
	populateLesserToNet()
	populateLessers()
	drawBoard()
	setColor(1, Color(1.0, 0.0, 0.0, 1.0))