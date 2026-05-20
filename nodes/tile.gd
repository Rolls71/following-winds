class_name Tile extends Resource

enum Elevations {OCEANWATER, COASTALWATER, COASTLAND, LOWLAND, HIGHLAND}
enum Gradients {FLAT, GENTLE, STEEP}

static func classify_elevation(e):
	if e < 0.4:
		return Elevations.OCEANWATER
	elif e < 0.45:
		return Elevations.COASTALWATER
	elif e < 0.5:
		return Elevations.COASTLAND
	elif e < 0.6:
		return Elevations.LOWLAND
	else:
		return Elevations.HIGHLAND

#static func classify_gradient(g):
	#pass

var position: Vector2i
var latitude: int ## y position
var longitude: int  ## x position
var elevation: float ## 
var gradient: float 

func _init(x: int, y: int, e: float, g: float):
	position = Vector2i(x, y)
	latitude = y
	longitude = x
	elevation = e
	gradient = g
	
