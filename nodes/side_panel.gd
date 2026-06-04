extends VBoxContainer

@export var label: Label

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		accept_event()

func display_selected(selected: Object):
	label.text = selected.get_class()
