class_name player extends CharacterBody2D

@export var speed := 200.0
@export var max_health := 50.0
@export var attack_delay := 0.8
@export var Projectile:PackedScene

var target:Vector2
var attack_timer:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer = 0

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
	owner.add_child(projectile)
	projectile.transform = transform
	
	if projectile is goldfish:
		var goldfish_projectile = projectile as goldfish
		goldfish_projectile.direction = global_position.direction_to(target)
		goldfish_projectile.look_at(target)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if attack_timer > 0:
			return
		target = get_global_mouse_position()
		attack_timer = attack_delay
		shoot()
