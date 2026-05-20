class_name Tile extends Resource

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
