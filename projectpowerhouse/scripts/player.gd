class_name player extends CharacterBody2D

@export var speed := 200.0
@export var max_health := 50.0
@export var attack_delay := 0.8
@export var Projectile:PackedScene

var target:Vector2
var attack_timer:float
var health:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer = 0
	health = max_health

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	velocity = input_direction * speed
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	if attack_timer > 0:
		attack_timer -= delta

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

func shoot():
	var projectile = Projectile.instantiate()
	get_parent().add_child(projectile)
	projectile.transform = global_transform
	
	if projectile is goldfish:
		var goldfish_projectile = projectile as goldfish
		goldfish_projectile.direction = global_position.direction_to(target)
		goldfish_projectile.look_at(target)
	elif projectile is antibody:
		var antibody_projectile = projectile as antibody
		antibody_projectile.direction = global_position.direction_to(target)
		antibody_projectile.look_at(target)

func die():
	queue_free()

func take_damage(amount: float):
	health -= amount
	if (health <= 0):
		die()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if attack_timer > 0:
			return
		target = get_global_mouse_position()
		attack_timer = attack_delay
		shoot()
