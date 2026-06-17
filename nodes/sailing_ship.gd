extends Node2D


var push_force: float = 1
var mass: float = 1

var push_dir: Vector2
var push: Vector2
var heading
var angle_diff: float

var velocity: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	push_dir = get_local_mouse_position()
	angle_diff = get_angle_to(push_dir)
	
	var propulsion = Vector2.from_angle(rotation)*push_force*cos(angle_diff)
	velocity = velocity + (propulsion*delta)
	position += velocity
