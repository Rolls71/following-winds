class_name ObjectMap extends TileMapLayer

var is_cell_selected = false
var selected_cell: Vector2i


		

func select(map_pos: Vector2i):
	deselect()
	selected_cell = map_pos
	set_cell(selected_cell, 0, Vector2i(0,1))
	is_cell_selected = true

func deselect():
	set_cell(selected_cell)
	is_cell_selected = false
