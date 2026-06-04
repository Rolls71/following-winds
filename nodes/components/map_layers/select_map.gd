class_name SelectMap extends TileMapLayer

var is_cell_selected = false
var selected_cell: Vector2i


		

func select_cell(cell: Vector2i):
	deselect()
	selected_cell = cell
	set_cell(cell, 0, Vector2i(0,1))
	is_cell_selected = true
	return self

func deselect():
	set_cell(selected_cell)
	is_cell_selected = false
