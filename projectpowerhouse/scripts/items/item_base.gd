class_name item_base extends Node2D

@export var size_in_inv := Vector2i.ONE

# TODO: ATTRIBUTES

var my_inventory:inv = null

func is_in_inv() -> bool:
	return my_inventory != null;

func set_inv(inventory:inv) -> void:
	if (is_in_inv() && inventory == null):
		# We were in an inventory, now we're not
		var i = my_inventory
		my_inventory = null
		i.remove_item(self)
		queue_free()
	my_inventory = inventory
