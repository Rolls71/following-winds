extends Camera2D
class_name PanningCamera

const MIN_ZOOM: float = 0.05
const MAX_ZOOM: float = 2.0
const ZOOM_RATE: float = 8.0
const ZOOM_INCREMENT: float = 0.1

var _target_zoom: float = 1.0


func _process(_delta: float):
	if $"..".selected is Ship:
		position = $"..".selected.position

func _physics_process(delta: float) -> void:
	zoom = lerp(zoom, _target_zoom * Vector2.ONE, ZOOM_RATE * delta)
	set_physics_process(not is_equal_approx(zoom.x, _target_zoom))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if Input.is_action_just_pressed("zoom_in"):
				zoom_in()
			if Input.is_action_just_pressed("zoom_out"):
				zoom_out()
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("pan"):
			position -= event.relative / zoom


func zoom_in() -> void:
	_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)


func zoom_out() -> void:
	_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)
