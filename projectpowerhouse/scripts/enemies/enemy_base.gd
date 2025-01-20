class_name enemy_base extends Area2D

@export var health := 1.0
@export var damage := 1.0
@export var defence := 1.0
@export var durability := 1.0
@export var move_speed := 1.0
@export var acceleration := 0.5
@export var attack_speed := 1.0
@export var player_node:player

@export var enemy_pushback_amount := 0.9

signal on_attack
signal on_damaged(amount: float)
signal on_death

var collided_player:player = null;
var velocity := Vector2.ZERO;
var time_since_attack := 0.0;

func _ready() -> void:
	pass

func init(player_node: player):
	self.player_node = player_node

func _process(delta: float) -> void:
	if (collided_player != null):
		if (time_since_attack >= attack_speed):
			time_since_attack = 0;
			perform_attack()

func _physics_process(delta: float) -> void:
	position += velocity * delta;
	time_since_attack += delta;

func _on_body_entered(body: Node2D) -> void:
	# TODO: Check if body is player
	if (body is player):
		collided_player = body as player
	pass

func _on_body_exited(body: Node2D) -> void:
	# TODO: Check if body is player
	if (body is player):
		collided_player = null;
	pass

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if (area is enemy_base):
		# TODO: Get collision normal and overlap and move away accordingly
		position += area.position.direction_to(position) * enemy_pushback_amount

func _on_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.

func perform_attack():
	on_attack.emit()
	print(name + " attacked player")
	pass

#################### PUBLIC FUNKIES ####################
func take_damage(amount: float) -> void:
	health -= amount
	on_damaged.emit(amount)
	if (health <= 0):
		die()

func die() -> void:
	on_death.emit()
	queue_free()

func move(move_to: Vector2, dt: float) -> void:
	var angle = position.angle_to_point(move_to)
	var angleVec = Vector2.from_angle(angle)
	var movement = angleVec * move_speed;
	velocity = velocity.lerp(movement, acceleration * dt);
