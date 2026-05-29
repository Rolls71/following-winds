class_name TerrainMap extends TileMapLayer

@export var is_draw_wind = true

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


func _draw():
	if not is_draw_wind:
		return
	for pos in $"..".tiles:
		var tile: Tile = $"..".tiles[pos]
		var p = map_to_local(tile.position)
		var line = Line2D.new()
		line.add_point(p)
		line.add_point(p+(30*tile.wind))
		
		line.width = 5.0
		line.default_color = Color.RED
		add_child(line)
		
