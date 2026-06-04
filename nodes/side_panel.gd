extends VBoxContainer

@onready var label: RichTextLabel = $PanelContainer/Panel/Label

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		accept_event()

func display_selected(selected: Object):
	match selected.get_script().get_global_name():
		"Ship":
			pass
		"Tile":
			display_tile(selected)
		
func display_tile(tile: Tile):
	var str = " {0}  {1}  [img]res://resources/mountain-icon.png[/img] {2}m"
	label.text = str.format([
		str(tile.position), 
		Tile.TERRAIN_STRINGS[tile.get_terrain()], 
		int(pow((tile.elevation - Tile.SEA_LEVEL) * 100, 2) * sign(tile.elevation - Tile.SEA_LEVEL))
	])
