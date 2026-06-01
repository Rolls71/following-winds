class_name Ship extends Node2D

@export var world: World
@export var speed: float = 25
@export var turn_rate: float = 8.0

var tile_pos: Vector2i
var map_pos: Vector2


var is_selected: bool = false
var polygon: PackedVector2Array

func _ready() -> void:
	polygon = $Hull/Area2D/CollisionPolygon2D.polygon
	if self not in world.ships:
		world.ships.append(self)

func _process(delta: float) -> void:
	if not is_selected:
		return
	map_pos = world.terrain_map.local_to_map(position)
	tile_pos = map_pos
	var winds = get_local_winds()
	var wind_sum = Vector2.ZERO
	for wind in winds:
		wind_sum += wind
	position += delta*wind_sum*speed
	rotation = lerp(rotation, wind_sum.angle(), turn_rate * delta)

func get_local_winds() -> Array[Vector2]:
	var winds: Array[Vector2] = []
	if not world.tiles.has(tile_pos):
		push_error("no tile to get winds from here")
		return []
	var neighbourhood = world.get_neighbourhood(tile_pos)
	for tile in neighbourhood:
		winds.append(tile.wind * (1/(1.0+tile.position.distance_squared_to(map_pos))))
	return winds

func select():
	is_selected = true
	$Hull/Selected.visible = is_selected

func deselect():
	is_selected = false
	$Hull/Selected.visible = is_selected
