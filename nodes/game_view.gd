class_name GameView extends Control

var gold_text: String = "Gold: " 
var gold_val: float = 0.0
@export var gold_label: Label

@onready var sidepanel = $CanvasLayer/HBoxContainer/SidePanel
@onready var selectmap = $World/SelectMap
@onready var world = $World
var selected
var deselector

func _process(_delta: float) -> void:
	update_resources()

func update_resources():
	gold_label.text = gold_text + str(gold_val)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_released("select"):
			handle_click(event)
		if Input.is_action_just_released("deselect"):
			if deselector:
				deselector.deselect()

func handle_click(event: InputEvent):
	accept_event()
	var pos = get_local_mouse_position()
	if deselector: 
		deselector.deselect()
	for ship in world.ships:
		if Geometry2D.is_point_in_polygon(pos, ship.polygon):
			ship.select()
			
			selected = ship
			deselector = ship
			sidepanel.display_selected(selected)
			return
	var map_pos = selectmap.local_to_map(get_local_mouse_position())
	selectmap.select_cell(map_pos)
	
	selected = world.tiles[map_pos]
	deselector = selectmap
	sidepanel.display_selected(selected)
