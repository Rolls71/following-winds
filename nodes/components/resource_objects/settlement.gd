class_name Settlement extends Resource

var id: int
var name: String
var center: Tile
var tiles: Dictionary[Vector2i, Tile]

func _init(i: int, n: String, c: Tile):
	id = i
	name = n
	center = c
	tiles[center.position] = center
