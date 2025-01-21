class_name item_base extends Node2D

@export var size_in_inv := Vector2i.ONE

var is_in_inv := false

func get_in_inv() -> bool:
	return is_in_inv;

func set_in_inv(value:bool) -> void:
	if (is_in_inv && value == false):
		queue_free()
	is_in_inv = value
