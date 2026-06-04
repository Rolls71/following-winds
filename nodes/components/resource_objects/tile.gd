class_name Tile extends Resource

enum Elevations {OCEANWATER, COASTALWATER, COASTLAND, LOWLAND, HIGHLAND}
const TERRAIN_STRINGS = ["Ocean Waters", "Coastal Waters", "Coastlands", "Lowlands", "Highlands"]
enum Gradients {FLAT, GENTLE, STEEP}
enum Buildings {DOCKS, TOWN_HALL, WAREHOUSE}

const OCEAN_COAST_LEVEL: float = 0.62
const SEA_LEVEL: float = 0.685
const COAST_LOW_LEVEL: float = 0.7
const LOW_HIGH_LEVEL: float = 0.77



static func classify_elevation(e):
	if e < OCEAN_COAST_LEVEL:
		return Elevations.OCEANWATER
	elif e < SEA_LEVEL:
		return Elevations.COASTALWATER
	elif e < COAST_LOW_LEVEL:
		return Elevations.COASTLAND
	elif e < LOW_HIGH_LEVEL:
		return Elevations.LOWLAND
	else:
		return Elevations.HIGHLAND

static func classify_gradient(g):
	if g < 0.2:
		return Gradients.FLAT
	elif g < 0.4:
		return Gradients.GENTLE
	else:
		return Gradients.STEEP

var position: Vector2i
var latitude: float ## y position
var longitude: float  ## x position
var elevation: float ## 
var gradient: float 
var climate_zone: float ## Scale from 0 (equatorial) to 1 (polar) based on latitude
var temperature: float ## Percentage based on elevation, and climate zone
var bounds: Vector2i
var owner: Settlement
var building: Buildings
var wind: Vector2
var slope: Vector2
var coriolis: Vector2
#var precipitation: float ## Percentage of days with rainfall, ranging from 0-200/365


func _init(x: int, y: int, e: float, g: float, b: Vector2i, c: float, t: float):
	position = Vector2i(x, y)
	latitude = y / float(b.y/2.0)
	longitude = x / float(b.x)
	elevation = e
	gradient = g
	climate_zone = c
	temperature = t
	bounds = b
	
	
	
	
	
func get_terrain():
	return classify_elevation(elevation)



func build(b: Buildings, s: Settlement):
	building = b
	owner = s

	
