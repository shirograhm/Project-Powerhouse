extends Node

@export var parent: enemy_base
@export var USE_DEBUG_MOVEMENT:bool = false
@export var DEBUG_MOVE_TO:Vector2

func _physics_process(delta: float) -> void:
	if (USE_DEBUG_MOVEMENT):
		parent.move(DEBUG_MOVE_TO, delta)
	elif (parent.player != null):
		parent.move(parent.player.position, delta)
