class_name enemy_base extends Area2D

@export var player_node:player

@export var enemy_pushback_amount := 0.9

# Unit Stats (TODO: Consolidate into a separate file?)
@export var max_health   :=  1.0
@export var health       :=  1.0
@export var damage       :=  1.0
@export var atk_speed    :=  1.0
@export var defense      :=  0.0
@export var durability   :=  0.0
@export var crit_chance  :=  0.0
@export var crit_damage  :=  0.0
@export var movespeed    := 50.0
@export var acceleration :=  0.5

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
		if (time_since_attack >= atk_speed):
			time_since_attack = 0;
			perform_attack()

func _physics_process(delta: float) -> void:
	position += velocity * delta;
	time_since_attack += delta;

func _on_body_entered(body: Node2D) -> void:
	if (body is player):
		collided_player = body as player
	pass

func _on_body_exited(body: Node2D) -> void:
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
	player_node.take_damage(self, damage, self.roll_crit())

#################### PUBLIC FUNKIES ####################
func take_damage(amount: float, is_crit: bool) -> void:
	var post_mitigated = Global.get_mitigation(self.defense, self.durability, amount)
	Global.spawn_number_popup(post_mitigated, Global.NumberType.DAMAGE, is_crit, self)
	health -= post_mitigated
	on_damaged.emit(amount)
	if (health <= 0):
		die()

func roll_crit() -> bool:
	return crit_chance > Global.rng.randf()

func get_current_health() -> float:
	return health

func get_max_health() -> float:
	# return max_health
	return 0.0

func die() -> void:
	var weights:PackedFloat32Array
	for i in range(ResourceManager.item_drops.size()):
		var weight = ResourceManager.item_drops[i].spawn_chance;
		weights.append(weight)
	
	var index = Global.rng.rand_weighted(weights)
	var item = ResourceManager.item_drops[index].scene.instantiate() as item_base
	item.transform = transform
	call_deferred("add_sibling", item)
	SoundManager.play_sound(SoundManager.sound_effect.BOO_WOO_WOO)
	on_death.emit()
	queue_free()

func move(move_to: Vector2, dt: float) -> void:
	var angle = position.angle_to_point(move_to)
	var angleVec = Vector2.from_angle(angle)
	var movement = angleVec * movespeed;
	velocity = velocity.lerp(movement, acceleration * dt);
