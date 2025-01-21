class_name inv extends Node2D

const GRID_SIZE := 32

@export var size := Vector2i.ONE

# map (x, y) -> item_base
# defines pos for each item size
var inventory := {}

func _ready() -> void:
	var area = $Area2D
	area.position += size * GRID_SIZE * .5
	var collision_shape = $Area2D/CollisionShape2D
	var shape := RectangleShape2D.new()
	shape.size = size * GRID_SIZE
	collision_shape.shape = shape

func can_place(item:item_base) -> bool:
	var item_size = item.size_in_inv;
	var item_pos = world_to_grid(item.global_position) - get_my_grid_pos();
	for x in range(item_size.x):
		for y in range(item_size.y):
			var pos := Vector2i(item_pos + Vector2i(x, y))
			if (pos.x < 0 || pos.y < 0 || 
				pos.x > size.x || pos.y > size.y || 
				inventory.has(pos)):
				return false
	return true

func place_item(item:item_base) -> bool:
	if (can_place(item) == false):
		return false;
	var item_size = item.size_in_inv;
	var item_pos = world_to_grid(item.global_position) - get_my_grid_pos();
	for x in range(item_size.x):
		for y in range(item_size.y):
			var pos := Vector2i(item_pos + Vector2i(x, y))
			inventory[pos] = item
	item.get_parent().remove_child(item)
	add_child(item)
	item.position = grid_to_world(item_pos) - Vector2i.ONE * GRID_SIZE * .5
	item.set_inv(self)
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
	remove_child(item)
	item.set_inv(null)
	if (erase_keys.size() > 0):
		print("Removed " + item.name)
	else:
		print("Item " + item.name + " was not found in inv")
	return erase_keys.size() > 0;

func get_my_grid_pos() -> Vector2i:
	return world_to_grid(position)

func _draw() -> void:
	draw_circle(position, 8, Color.AQUAMARINE)
	var square_size = Vector2.ONE * GRID_SIZE;
	for x in range(size.x):
		for y in range(size.y):
			var pos = grid_to_world(Vector2i(x, y))
			draw_rect(Rect2(pos, square_size), Color.AQUA, false)

#################### STATIC GRID FUNKIES ####################

static func snap_to_grid(pos:Vector2) -> Vector2:
	return pos.snapped(Vector2(GRID_SIZE, GRID_SIZE))

static func world_to_grid(pos:Vector2) -> Vector2i:
	return snap_to_grid(pos) / GRID_SIZE

static func grid_to_world(pos:Vector2i) -> Vector2:
	return pos * GRID_SIZE;
