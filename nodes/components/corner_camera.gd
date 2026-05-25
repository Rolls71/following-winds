extends Camera2D

@export var main_cam: Camera2D

func _process(_delta: float) -> void:
	global_position = main_cam.global_position
