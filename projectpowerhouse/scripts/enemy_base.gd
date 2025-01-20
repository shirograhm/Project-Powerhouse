extends Area2D

@export var health := 1
@export var damage := 1
@export var defence := 1
@export var durability := 1
@export var move_speed := 1
@export var attack_speed := 1

@export var USE_DEBUG_MOVEMENT:bool = false
@export var DEBUG_MOVE_TO:Vector2

var player:PhysicsBody2D;

func _ready() -> void:
	# TODO: Find player in tree
	# player = FindPlayerInTree()
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if (USE_DEBUG_MOVEMENT):
		move(DEBUG_MOVE_TO, delta)
	elif (player != null):
		move(player.position, delta)
		

func take_damage(amount: int) -> void:
	health -= amount
	if (health <= 0):
		die()

func die():
	pass

func move(move_to: Vector2, dt: float) -> void:
	var angle = position.angle_to_point(move_to)
	var angleVec = Vector2.from_angle(angle)
	var movement = angleVec * move_speed * dt;
	position += movement;
