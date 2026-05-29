class_name Ship extends Node2D

var is_selected: bool = false
var polygon: PackedVector2Array

func _ready() -> void:
	polygon = $Hull/Area2D/CollisionPolygon2D.polygon

func select():
	is_selected = true
	$Hull/Selected.visible = is_selected

func deselect():
	is_selected = false
	$Hull/Selected.visible = is_selected
