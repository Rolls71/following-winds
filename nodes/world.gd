class_name World extends Node

var sample_distance: float = 2
var gradient_multiplier: float = 40/sample_distance ## Derived from 1/gradient_max
var width = 400
var height = 400

var rng: RandomNumberGenerator
var tiles: Dictionary[Vector2i, Tile]
var fnl_terrain: FastNoiseLite
var fnl_plates: FastNoiseLite


func _init(s: int = Time.get_ticks_usec()):
	rng = RandomNumberGenerator.new()
	rng.seed = s
	
	fnl_terrain = FastNoiseLite.new()
	fnl_terrain.seed = s
	fnl_terrain.noise_type = FastNoiseLite.TYPE_SIMPLEX
	fnl_terrain.frequency = 0.05
	fnl_terrain.fractal_octaves = 4
	fnl_terrain.fractal_lacunarity = 2
	fnl_terrain.fractal_gain = 0.5
	fnl_terrain.offset = Vector3(s,s,0)
	
	fnl_plates = FastNoiseLite.new()
	fnl_plates.seed = s
	fnl_plates.noise_type = FastNoiseLite.TYPE_CELLULAR
	fnl_plates.cellular_distance_function = FastNoiseLite.DISTANCE_EUCLIDEAN_SQUARED
	fnl_plates.frequency = 0.015
	fnl_plates.fractal_octaves = 3
	fnl_plates.fractal_lacunarity = 7
	fnl_plates.fractal_gain = 0.15
	fnl_plates.offset = Vector3(s,s,0)
	
	


func _ready() -> void:
	var img: Image = Image.create_empty(width, height, false, Image.FORMAT_RGB8)
	var texture = ImageTexture.create_from_image(img)
	
	for x in range(-(width/2.0),width-(width/2.0)):
		for y in range(-(height/2.0),height-(height/2.0)):
			var e = (fnl_plates.get_noise_2d(x, y)+1)/2.0
			img.set_pixel(x+width/2, y+height/2, Color.WHITE * e)
	texture = ImageTexture.create_from_image(img)
	$Container/Centre/PlateMap.texture = texture
	
	for x in range(-(width/2.0),width-(width/2.0)):
		for y in range(-(height/2.0),height-(height/2.0)):
			var e = (fnl_terrain.get_noise_2d(x, y)+1)/2.0
			img.set_pixel(x+width/2, y+height/2, Color.WHITE * e)
	texture = ImageTexture.create_from_image(img)
	$Container2/Centre/TerrainMap.texture = texture
	
	for x in range(-(width/2.0),width-(width/2.0)):
		for y in range(-(height/2.0),height-(height/2.0)):
			var e = get_elevation(x, y)
			img.set_pixel(x+width/2, y+height/2, Color.WHITE * sobel_sample_gradient(Vector2i(x, y), e))
	texture = ImageTexture.create_from_image(img)
	$Container3/Centre/GradientMap.texture = texture
	
	for x in range(-(width/2.0),width-(width/2.0)):
		for y in range(-(height/2.0),height-(height/2.0)):
			var e = get_elevation(x, y)
			img.set_pixel(x+width/2, y+height/2, Color.WHITE * e)
	texture = ImageTexture.create_from_image(img)
	$Container4/Centre/TerrainPlateMap.texture = texture

	for x in range(-(width/2.0),width-(width/2.0)):
		for y in range(-(height/2.0),height-(height/2.0)):
			var e = get_elevation(x, y)
			img.set_pixel(x+width/2, y+height/2, 
				Color.WHITE * Palette.elevations_to_colour[Tile.classify_elevation(e)])

	texture = ImageTexture.create_from_image(img)
	$Container5/Centre/ColourMap.texture = texture
	
	
	for x in range(-(width/2.0),width-(width/2.0)):
		for y in range(-(height/2.0),height-(height/2.0)):
			var e = get_elevation(x, y)
			var h = 2*sqrt(1/Tile.LOW_HIGH_LEVEL)*max(e - Tile.LOW_HIGH_LEVEL,0)
			var c = 1-(abs(y)/(height/2.0))
			var t = max(0, (c*0.8)+0.2-h)
			var gradient = Gradient.new()
			gradient.set_color(1, Color.from_rgba8(237, 247, 1))
			gradient.set_color(0, Color.from_rgba8(3, 43, 175))
			gradient.add_point(0.7, Color.from_rgba8(38, 250, 8))
			gradient.add_point(0.6, Color.from_rgba8(8, 247, 233))
			gradient.add_point(0.1, Color.from_rgba8(3, 43, 175))
			img.set_pixel(x+width/2, y+height/2, gradient.sample(t))

	texture = ImageTexture.create_from_image(img)
	$Container6/Centre/ClimateMap.texture = texture


func get_elevation(x: int, y: int):
	var terrain_height = (fnl_terrain.get_noise_2d(x, y)+1)/2.0
	var plate_height = (fnl_plates.get_noise_2d(x, y)+1)/2.0
	var t: float = 1
	var p: float = 3
	var bal: float = 0.1*(t+p)
	return (pow(terrain_height,bal*(1/t)) * pow(plate_height,bal*(1/p)))


	


func discover(pos: Vector2i):
	if tiles.has(pos):
		push_warning("Tile at "+str(pos)+" already discovered.")
		return tiles[pos]
	var elevation = (fnl_terrain.get_noise_2dv(pos)+1)/2.0
	var gradient = sobel_sample_gradient(pos, elevation)
	var tile: Tile = Tile.new(pos.x, pos.y, elevation, gradient, Vector2i(width, height))
	tiles[pos] = tile
	return tile
	
	

## Calculates the gradient of a point based on the 8 surrounding points.
## Returns a float value:
## 0 → perfectly flat,
## 1 → 45° incline,
## >1 → steeper than 45°
func sobel_sample_gradient(pos: Vector2i, elevation):
	#z1 z2 z3
	#z4 z5 z6
	#z7 z8 z9
	var elevations: Array[float] = []
	if elevation <= 0:
		push_error("Elevation is 0 or below")
	var e = max(elevation, 0.00000000000001)
	for x: float in [-1,0,1]:
		for y: float in [-1,0,1]:
			elevations.append(get_elevation(x, y))
	var zx_slope = ((elevations[2]+2*elevations[5]+elevations[8])-(elevations[0]+2*elevations[5]+elevations[6]))/8*e
	var zy_slope = ((elevations[6]+2*elevations[7]+elevations[8])-(elevations[0]+2*elevations[1]+elevations[2]))/8*e
	return sqrt(pow(zx_slope,2) + pow(zy_slope,2))
