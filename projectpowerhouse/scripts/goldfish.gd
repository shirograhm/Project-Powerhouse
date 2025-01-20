class_name goldfish extends Area2D

@export var lifetime := 10.0
@export var direction:Vector2
@export var speed := 300.0
@export var damage := 5.0

var collided_enemy:enemy_base = null;
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
	position += direction.normalized() * speed  * delta


func handle_collision(collided: Node2D):
	if collided is enemy_base:
		print("is enemy base")
		collided_enemy = collided as enemy_base
		collided_enemy.take_damage(damage)
		queue_free()
	else:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	handle_collision(body)
		

func _on_area_entered(area: Area2D) -> void:
	handle_collision(area)
