class_name World extends Node

var sample_rate: float = 0.1
var width = 800
var height = 800

var rng: RandomNumberGenerator
var tiles: Dictionary[Vector2i, Tile]
var fnl: FastNoiseLite


func _init(s: int = Time.get_ticks_usec()):
	rng = RandomNumberGenerator.new()
	rng.seed = s
	fnl = FastNoiseLite.new()
	fnl.seed = s
	
	fnl.frequency = 0.005
	fnl.fractal_octaves = 4
	fnl.fractal_lacunarity = 2
	fnl.fractal_gain = 0.5
	fnl.offset = Vector3(s,s,0)


func _ready() -> void:
	var img: Image = Image.create_empty(width, height, false, Image.FORMAT_RGB8)
	for x in range(width):
		for y in range(height):
			img.set_pixel(x,y,classify_elevation(fnl.get_noise_2d(x,y)))
	var texture = ImageTexture.create_from_image(img)
	$Sprite2D.texture = texture
	
	print(discover(Vector2i(0,0)).elevation)
	print(discover(Vector2i(0,0)).gradient)
	


	
func classify_elevation(e):
	if e < 0.45:
		return Palette.ocean
	elif e < 0.5:
		return Palette.sand
	elif e < 0.6:
		return Palette.grass
	else:
		return Palette.mountain

func discover(pos: Vector2i):
	if tiles.has(pos):
		push_warning("Tile at "+str(pos)+" already discovered.")
		return tiles[pos]
	var elevation = (fnl.get_noise_2dv(pos)+1)/2.0
	var gradient = sobel_sample_gradient(pos, elevation)
	var tile: Tile = Tile.new(pos.x, pos.y, elevation, gradient)
	tiles[pos] = tile
	return tile
	
	

## Calculates the gradient of a point based on the 8 surrounding points.
## Returns a float value:
## 0 → perfectly flat,
## 1 → 45° incline,
## >1 → steeper than 45°
func sobel_sample_gradient(pos: Vector2i, h):
	#z1 z2 z3
	#z4 z5 z6
	#z7 z8 z9
	var heights: Array[float] = []
	for x: float in [-1,0,1]:
		for y: float in [-1,0,1]:
			heights.append(fnl.get_noise_2d(pos.x+(x*sample_rate), pos.y+(y*sample_rate)))
	var zx_slope = ((heights[2]+2*heights[5]+heights[8])-(heights[0]+2*heights[5]+heights[6]))/8*h
	var zy_slope = ((heights[6]+2*heights[7]+heights[8])-(heights[0]+2*heights[1]+heights[2]))/8*h
	return sqrt(pow(zx_slope,2) + pow(zy_slope,2))
