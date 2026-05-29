class_name GameView extends Control

var gold_text: String = "Gold: " 
var gold_val: float = 0.0
@export var gold_label: Label

var selected

func _process(_delta: float) -> void:
	update_resources()

func update_resources():
	gold_label.text = gold_text + str(gold_val)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_released("select"):
			handle_click(event)
		if Input.is_action_just_released("deselect"):
			if selected:
				selected.deselect()

func handle_click(event: InputEvent):
	accept_event()
	var pos = get_local_mouse_position()
	if selected: 
		selected.deselect()
	for ship in $World.ships:
		if Geometry2D.is_point_in_polygon(pos, ship.polygon):
			ship.select()
			selected = ship
			return
	if selected: 
		selected.deselect()
	selected = $World/SelectMap.select(event)
	
	
	
