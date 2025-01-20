extends Area2D

class_name enemy_base

@export var health := 1.0
@export var damage := 1.0
@export var defence := 1.0
@export var durability := 1.0
@export var move_speed := 1.0
@export var acceleration := 0.5
@export var attack_speed := 1.0

signal on_damaged(amount: float)
signal on_death

var is_colliding_with_player := false
var velocity := Vector2.ZERO;

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	position += velocity * delta;

func _on_body_entered(body: Node2D) -> void:
	# TODO: Check if body is player
	pass

func _on_body_exited(body: Node2D) -> void:
	# TODO: Check if body is player
	pass

#################### PUBLIC FUNKIES ####################
func take_damage(amount: float) -> void:
	health -= amount
	on_damaged.emit(amount)
	if (health <= 0):
		die()

func die() -> void:
	on_death.emit()

func move(move_to: Vector2, dt: float) -> void:
	var angle = position.angle_to_point(move_to)
	var angleVec = Vector2.from_angle(angle)
	var movement = angleVec * move_speed;
	velocity = velocity.lerp(movement, acceleration * dt);
