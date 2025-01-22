class_name player extends CharacterBody2D

@export var Projectile:PackedScene

@onready var iframe_timer := $IFrameTimer
@onready var attack_timer := $AttackTimer

var is_iframe_active = false
var can_attack = true
var is_dead = false

# Unit Stats (TODO: Consolidate into a separate file?)
var max_health: float  = Global.BASE_MAX_HEALTH
var health: float      = Global.BASE_MAX_HEALTH
var defense: float     = 0.0
var durability: float  = 0.0
var crit_chance: float = Global.BASE_CRIT_CHANCE
var crit_damage: float = Global.BASE_CRIT_DAMAGE
var movespeed: float   = Global.BASE_MOVE_SPEED

var target:Vector2
var set_attack := attack_type.RANGED

# Will need to change with items system
enum attack_type {RANGED, AUTO, MELEE}

# TODO need auto attack and close range attack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func get_input():
	if is_dead:
		return
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * movespeed

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

func shoot():
	if set_attack == attack_type.AUTO:
		# current attack is auto NYI
		print("auto attack")
	if set_attack == attack_type.MELEE:
		# current attack is melee NYI
		print("melee attack")
	else:
		SoundManager.play_sound(SoundManager.sound_effect.SHOTGUN_SHOOT)
		var projectile = Projectile.instantiate()
		projectile.set_player(self)
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
	# TODO popup menu
	is_dead = true
	print("You died")

func take_damage(attacker: enemy_base, amount: float, is_crit: bool):
	if is_iframe_active:
		return
	else:
		is_iframe_active = true
		iframe_timer.start(Global.IFRAME_DELAY)
		var post_mitigated = Global.get_mitigation(self.defense, self.durability, amount)
		Global.spawn_number_popup(post_mitigated, Global.NumberType.DAMAGE, is_crit, self)
		health -= post_mitigated
		if (health <= 0):
			die()

func roll_crit() -> bool:
	return crit_chance > Global.rng.randf()

func get_crit_damage() -> float:
	return crit_damage

func get_current_health() -> float:
	return health

func get_max_health() -> float:
	return max_health

func _input(event: InputEvent) -> void:
	if can_attack and event.is_action_pressed("shoot"):
		target = get_global_mouse_position()
		attack_timer.start(1 / Global.BASE_ATTACK_SPD)
		can_attack = false
		shoot()

func _on_attack_timer_timeout() -> void:
	can_attack = true

func _on_i_frame_timer_timeout() -> void:
	is_iframe_active = false
