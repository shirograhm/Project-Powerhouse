class_name projectile_base extends Area2D

@export var lifetime := 10.0
@export var direction:Vector2
@export var speed := 300.0
@export var damage := 5.0
@export var spin_rate := 0

var player_node: player
var life_timer:float

func _ready() -> void:
	life_timer = lifetime

func _process(delta: float) -> void:
	if life_timer > 0:
		life_timer -= delta
	else:
		queue_free()
		
func handle_collision(collided: Node2D):
	pass

func set_player(node_in: player) -> void:
	self.player_node = node_in

func _physics_process(delta: float) -> void:
	position += direction.normalized() * speed  * delta
	if spin_rate > 0:
		$AnimatedSprite2D.rotation_degrees = $AnimatedSprite2D.rotation_degrees + spin_rate * delta
