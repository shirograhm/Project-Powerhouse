class_name item_base extends Node2D

@export var item_parent:Node = null
@export var points_in_inv:Array[Vector2i]

# TODO: ATTRIBUTES

var my_inventory:inv = null

func _ready() -> void:
	if (item_parent == null):
		item_parent = get_parent()

func is_in_inv() -> bool:
	return my_inventory != null;

func set_inv(inventory:inv, notifyInv:bool) -> void:
	if (is_in_inv() && inventory == null):
		# We were in an inventory, now we're not
		var i = my_inventory
		my_inventory = null
		if (notifyInv):
			i.remove_item(self)
	
	my_inventory = inventory
	
	if (my_inventory != null):
		if (get_parent() != my_inventory):
			get_parent().remove_child(self)
			my_inventory.add_child(self)
	else:
		var pos = global_position
		get_parent().remove_child(self)
		item_parent.add_child(self)
		global_position = pos
		
