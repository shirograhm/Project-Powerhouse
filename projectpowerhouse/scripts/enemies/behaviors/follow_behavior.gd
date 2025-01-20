extends Node

@export var parent: enemy_base
@export var USE_DEBUG_MOVEMENT:bool = false
@export var DEBUG_MOVE_TO:Vector2

func _ready() -> void:
	if (parent == null):
		printerr("No parent for " + name + ". Please assign it")

func _physics_process(delta: float) -> void:
	if (USE_DEBUG_MOVEMENT):
		parent.move(DEBUG_MOVE_TO, delta)
	elif (parent.player_node != null):
		parent.move(parent.player_node.position, delta)
