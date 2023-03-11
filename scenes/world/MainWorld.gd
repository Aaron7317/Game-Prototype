extends Node2D

# IDEA MAKE A SCENE FOR EACH CELL AND EXPORT PACKED SCENES HERE
# @export PackedScene default_cell_type <- this the world will use whatever this is to draw the tile 
# EACH CELL SCENE WILL BE A CELL NODE WITH ANY OTHER FUNCTIONALITY 
# Example create a breakable scene somewhere and add that to cells that should be breakable

@export var basic_ground : PackedScene
@export var empty_tile : PackedScene

var noise : FastNoiseLite = FastNoiseLite.new()
@export var noise_frequency : float = 0.0015 # Values closer to zero result in smoother terrain

@export var chunk_size : int = 16
var chunks = {}

var standard_layer = 0
var world_length = 64 * chunk_size
var world_depth = 16 * chunk_size
var world_height = 16 * chunk_size


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.seed = randi()
	noise.frequency = noise_frequency 
	
	
	for row in range(-world_depth / chunk_size, world_height / chunk_size):
		for col in range(0, world_length / chunk_size):
			chunks[Vector2i(col * chunk_size, row * chunk_size)] = _get_empty_chunk()
	
	
	$TileMap.clear()
	for x in range(0, world_length):
		var y_max = ceil(noise.get_noise_1d(x) * world_height)
		
		for y in range(y_max, world_depth):
			chunks[_get_nearest_chunk(Vector2i(x, y))][y % chunk_size][x % chunk_size] = 0
		
		for y in range (y_max, world_depth):
			var yy = noise.get_noise_2d(x, y)
			if abs(yy) < 0.04:
				chunks[_get_nearest_chunk(Vector2i(x, y))][y % chunk_size][x % chunk_size] = -1
		
	# eventually have chunks drawn dynamically
	#for i in chunks:
	#	$TileMap.set_cells_terrain_connect(0, _search_chunk_for_cell_type(i, 0), 0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func render(camera_position: Vector2, viewport_size: Vector2):
	pass

func _get_nearest_chunk(point : Vector2i) -> Vector2i:
	var nearest_chunk = Vector2i(0, 0)
	if (point.x < 0):
		nearest_chunk.x = point.x - (point.x % chunk_size) - chunk_size
	else:
		nearest_chunk.x = point.x - point.x % chunk_size
	if (point.y < 0):
		# I Could not tell you why the +1 is necessary but it fixes wierd generation
		nearest_chunk.y = (point.y + 1) - ((point.y + 1) % chunk_size) - chunk_size
	else:
		nearest_chunk.y = point.y - point.y % chunk_size
	return nearest_chunk

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
