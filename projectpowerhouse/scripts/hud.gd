extends Node

@export var player_path:NodePath

var player_node: player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_node = get_node(player_path) as player
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HealthPanel/Label.text = "Health: " + str(player_node.health)
