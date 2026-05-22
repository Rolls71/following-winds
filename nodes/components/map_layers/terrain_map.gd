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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_released("select"):
			$"../SelectMap".select(local_to_map(get_local_mouse_position()))
			print(local_to_map(get_local_mouse_position()))
		elif Input.is_action_just_released("deselect"):
			$"../SelectMap".deselect()
