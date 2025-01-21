extends Area2D

@export var my_item:item_base
@export var can_drag := true

var my_inventory:inv = null
var is_mouse_over := false
var is_dragging := false
var lock_position:Vector2

func _ready() -> void:
	if (my_item == null):
		my_item = get_parent()
	lock_position = my_item.position

func _process(delta: float) -> void:
	if (is_dragging):
		handle_drag();
	else:
		if (my_item.position != lock_position):
			my_item.position = lerp(my_item.position, lock_position, 5 * delta)

func handle_drag():
	my_item.global_position = inv.grid_to_world(
				inv.world_to_grid(
					get_viewport().get_mouse_position()
					)
				) - Vector2.ONE * inv.GRID_SIZE * .5;

func _mouse_enter() -> void:
	is_mouse_over = true;

func _mouse_exit() -> void:
	is_mouse_over = false;

func _unhandled_input(event: InputEvent) -> void:
	if (is_mouse_over && can_drag):
		if (event is InputEventMouseButton and event.is_pressed()):
			get_viewport().set_input_as_handled()
			if (is_dragging):
				is_dragging = false
				if (my_inventory != null):
					if (my_inventory.place_item(my_item)):
						lock_position = my_item.position
						print("Nice, i was put in inventory")
					else:
						print("Nope, not here")
				else:
					my_item.set_inv(null)
			else:
				is_dragging = true
				lock_position = my_item.position

func _on_area_entered(area: Area2D) -> void:
	if (area.get_parent() is inv):
		print("Entered inventory")
		my_inventory = area.get_parent() as inv

func _on_area_exited(area: Area2D) -> void:
	if (area.get_parent() is inv):
		print("Exited inventory")
		my_inventory = null
