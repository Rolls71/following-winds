class_name SelectMap extends TileMapLayer

var is_cell_selected = false
var selected_cell: Vector2i


		

func select(event: InputEvent):
	var map_pos = local_to_map(get_local_mouse_position())
	deselect()
	selected_cell = map_pos
	set_cell(selected_cell, 0, Vector2i(0,1))
	is_cell_selected = true
	return self

func deselect():
	set_cell(selected_cell)
	is_cell_selected = false
