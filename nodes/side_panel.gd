extends VBoxContainer

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		accept_event()
