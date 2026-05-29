class_name TerrainMap extends TileMapLayer

var tiles: Dictionary[Vector2i, Tile]
var width: int
var height: int

func init_world(t: Dictionary[Vector2i, Tile], w: int, h):
	tiles = t
	width = w
	height = h
	for pos in tiles:
		var tile = tiles[pos]
		set_cell(pos, 0, Vector2i(Tile.classify_elevation(tile.elevation), 0))
