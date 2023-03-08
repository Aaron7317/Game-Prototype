extends Node2D

var noise : FastNoiseLite = FastNoiseLite.new()

@export var chunk_size : int = 16
var chunks = {}

var standard_layer = 0
var world_length = 32 * chunk_size
var world_depth = 4 * chunk_size
var world_height = 8 * chunk_size




# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()
	noise.frequency = 0.001 # Values closer to zero result in smoother terrain
	
	
	for row in range(-world_depth / chunk_size, world_height / chunk_size):
		for col in range(0, world_length / chunk_size):
			chunks[Vector2i(col * chunk_size, row * chunk_size)] = _get_empty_chunk()
			

	
	$TileMap.clear()
	#This still draws weird but only sometimes
	for x in range(0, world_length):
		var y_max = ceil(noise.get_noise_1d(x) * world_height)
		
		for y in range(y_max, world_depth):
			chunks[_get_nearest_chunk(Vector2i(x, y))][y % chunk_size][x % chunk_size] = 0
	
	# eventually have chunks drawn dynamically
	for i in chunks:
		$TileMap.set_cells_terrain_connect(0, _search_chunk_for_cell_type(i, 0), 0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# THIS IS JUST A TEST (HAVE THE CAMERA SEND AN UPDATE SIGNAL WHEN IT MOVES AND THEN HAVE AN UPDATE_TILES FUNCTION)
	#for i in range():
	pass

func _get_nearest_chunk(point : Vector2i) -> Vector2i:
	return Vector2i(point.x - point.x % chunk_size, point.y - point.y % chunk_size)

func _get_cells_from_chunk(chunk_pos : Vector2i):
	var cells = []
	for r in chunks[chunk_pos]:
		for c in r:
			cells.append(c)
	return cells
	
func _get_chunk_cell_positions(chunk_pos: Vector2i):
	var cell_positions = []
	for r in chunks[chunk_pos]:
		for c in r:
			cell_positions.append(Vector2i(c, r))
	return cell_positions
	
func _search_chunk_for_cell_type(chunk_pos: Vector2i, cell_type: int):
	var matching_cells = []
	var r_counter = 0
	for r in chunks[chunk_pos]:
		var c_counter = 0
		for c in r:
			if c == cell_type:
				matching_cells.append(Vector2i(chunk_pos.x + c_counter, chunk_pos.y + r_counter))
			c_counter += 1 
		r_counter += 1
	return matching_cells
	
func _get_empty_chunk():
	var chunk = []
	for i in range(0, chunk_size):
		chunk.append([])
		for j in range(0, chunk_size):
			chunk[i].append(-1)
			
	return chunk
