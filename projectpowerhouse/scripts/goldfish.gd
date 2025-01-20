class_name goldfish extends Area2D

@export var lifetime := 10.0
@export var direction:Vector2
@export var speed := 300.0
@export var damage := 5.0



var life_timer:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	life_timer = lifetime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if life_timer > 0:
		life_timer -= delta
	else:
		queue_free()

func _physics_process(delta: float) -> void:
	if direction:
		position += direction * speed  * delta




func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
