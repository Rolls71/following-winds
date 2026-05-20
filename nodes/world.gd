class_name World extends Node

var sample_distance: float = 2
var gradient_multiplier: float = 40/sample_distance ## Derived from 1/gradient_max
var width = 300
var height = 300

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
			var h = (fnl.get_noise_2d(x, y)+1)/2.0
			img.set_pixel(x, y, Color.WHITE * sobel_sample_gradient(Vector2i(x, y), h))
			
	var texture = ImageTexture.create_from_image(img)
	$GradientMap.texture = texture
	
	for x in range(width):
		for y in range(height):
			var h = (fnl.get_noise_2d(x, y)+1)/2.0
			img.set_pixel(x, y, Color.WHITE * h)
	
	texture = ImageTexture.create_from_image(img)
	$HeightMap.texture = texture

	for x in range(width):
		for y in range(height):
			var h = (fnl.get_noise_2d(x, y)+1)/2.0
			img.set_pixel(x, y, 
				Color.WHITE * Palette.elevations_to_colour[Tile.classify_elevation(h)])
	
	texture = ImageTexture.create_from_image(img)
	$ColourHeightMap.texture = texture
	
	for x in range(width):
		for y in range(height):
			var h = (fnl.get_noise_2d(x, y)+1)/2.0
			var g = sobel_sample_gradient(Vector2i(x, y), h)
			img.set_pixel(x, y, 
				Color.WHITE * Palette.gradients_to_colour[Tile.classify_gradient(g)])
	
	texture = ImageTexture.create_from_image(img)
	$ColourGradientMap.texture = texture
	
	for x in range(width):
		for y in range(height):
			var h = (fnl.get_noise_2d(x, y)+1)/2.0
			var g = sobel_sample_gradient(Vector2i(x, y), h)
			img.set_pixel(x, y, 
				Color.WHITE * Palette.elevations_to_colour[Tile.classify_elevation(h)] * Palette.gradients_to_colour[Tile.classify_gradient(g)])

	texture = ImageTexture.create_from_image(img)
	$ColourMap.texture = texture

	


	


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
func sobel_sample_gradient(pos: Vector2i, height):
	#z1 z2 z3
	#z4 z5 z6
	#z7 z8 z9
	var heights: Array[float] = []
	var h = max(height, 0.000000000001)
	for x: float in [-1,0,1]:
		for y: float in [-1,0,1]:
			heights.append(fnl.get_noise_2d(pos.x+(x*sample_distance), pos.y+(y*sample_distance)))
	var zx_slope = ((heights[2]+2*heights[5]+heights[8])-(heights[0]+2*heights[5]+heights[6]))/8*h
	var zy_slope = ((heights[6]+2*heights[7]+heights[8])-(heights[0]+2*heights[1]+heights[2]))/8*h
	return gradient_multiplier * sqrt(pow(zx_slope,2) + pow(zy_slope,2))
