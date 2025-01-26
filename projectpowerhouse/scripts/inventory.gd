class_name inv extends Node2D

const GRID_SIZE := 32

# Note: renames to InventroyCollisionShape2D since player already has CollisionShape2D
@onready var collision_shape = $Area2D/InventoryCollisionShape2D

@export var size := Vector2i.ONE
@export var draw_color := Color.CYAN
@export var draw_fill_color := Color(.1, .1, .8, .2)

# map (x, y) -> item_base
# defines pos for each item size
var inventory := {}
static var _instance:inv = null;

func _ready() -> void:
	_instance = self;
	var area = $Area2D
	area.position += size * GRID_SIZE * .5
	var shape := RectangleShape2D.new()
	shape.size = size * GRID_SIZE
	collision_shape.shape = shape

func get_items() -> Array:
	return inventory.values()

func can_place(item:item_base) -> bool:
	var item_points = item.points_in_inv;
	var item_pos = relative_world_to_grid(item.global_position)
	for i in range(item_points.size()):
		var pos := Vector2i(item_pos + item_points[i])
		if (pos.x < 0 || pos.y < 0 || 
			pos.x >= size.x || pos.y >= size.y || 
			(inventory.has(pos) && inventory[pos] != item)):
			return false
	return true

func place_item(item:item_base) -> bool:
	if (can_place(item) == false):
		return false;
	if (contains_item(item)):
		remove_item(item)
	var item_points = item.points_in_inv;
	var item_pos = relative_world_to_grid(item.global_position)
	for i in range(item_points.size()):
		var pos := Vector2i(item_pos + item_points[i])
		inventory[pos] = item
	item.position = grid_to_world(item_pos) - get_grid_world_offset()
	item.set_inv(self, false)
	queue_redraw()
	return true;

func remove_item(item:item_base) -> bool:
	var erase_keys := []
	for key in inventory:
		var i = inventory[key]
		if (i == item):
			erase_keys.append(key)
			print("Erasing " + i.name + " at " + str(key))
	for i in range(erase_keys.size()):
		inventory.erase(erase_keys[i])
	item.set_inv(null, false)
	if (erase_keys.size() > 0):
		print("Removed " + item.name)
	else:
		print("Item " + item.name + " was not found in inv")
	queue_redraw()
	return erase_keys.size() > 0;

func contains_item(item:item_base):
	for key in inventory:
		var i = inventory[key]
		if (i == item):
			return true;
	return false;

func get_my_grid_pos() -> Vector2i:
	return world_to_grid(global_position)

func _draw() -> void:
	var square_size = Vector2.ONE * GRID_SIZE;
	for x in range(size.x):
		for y in range(size.y):
			var gridPos = Vector2i(x, y)
			var pos = grid_to_world(gridPos)
			var rect = Rect2(pos, square_size)
			if (inventory.has(gridPos)):
				draw_rect(rect, draw_fill_color, true)
			draw_rect(rect, draw_color, false)

#################### STATIC GRID FUNKIES ####################

static func relative_world_to_grid(pos:Vector2) -> Vector2i:
	if (_instance == null):
		printerr("No grid instance in scene")
		return Vector2i.ZERO
	var offset = Vector2(int(_instance.global_position.x) % GRID_SIZE, int(_instance.global_position.y) % GRID_SIZE)
	return world_to_grid(pos - offset) - _instance.get_my_grid_pos()

static func relative_grid_to_world(pos:Vector2i) -> Vector2:
	if (_instance == null):
		printerr("No grid instance in scene")
		return Vector2i.ZERO
	var offset = Vector2(int(_instance.global_position.x) % GRID_SIZE, int(_instance.global_position.y) % GRID_SIZE)
	return grid_to_world(pos) + offset + grid_to_world(_instance.get_my_grid_pos()) + get_grid_world_offset()

static func relative_snap_to_grid(pos:Vector2) -> Vector2:
	if (_instance == null):
		printerr("No grid instance in scene")
		return Vector2i.ZERO
	var offset = Vector2(int(_instance.global_position.x) % GRID_SIZE, int(_instance.global_position.y) % GRID_SIZE)
	return snap_to_grid(pos) + offset + get_grid_world_offset()

static func snap_to_grid(pos:Vector2) -> Vector2:
	return (pos).snapped(Vector2(GRID_SIZE, GRID_SIZE))

static func world_to_grid(pos:Vector2) -> Vector2i:
	return snap_to_grid(pos + get_grid_world_offset()) / GRID_SIZE

static func grid_to_world(pos:Vector2i) -> Vector2:
	return Vector2(pos) * GRID_SIZE;
	
static func get_grid_world_offset() -> Vector2:
	return -Vector2.ONE * GRID_SIZE * .5;
