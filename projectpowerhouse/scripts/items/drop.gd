class_name drop extends Area2D

@export var item:PackedScene
@export var type := 0

@onready var _animated = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if type == 0:
		_animated.play("flagella")
	elif type == 2:
		_animated.play("golgi")
	elif type == 3:
		_animated.play("mitochondria")
	elif type == 4:
		_animated.play("phospholipid")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handle_collision(node: Node2D):
	# TODO add item to player inventory
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	handle_collision(body)


func _on_area_entered(area: Area2D) -> void:
	handle_collision(area)
