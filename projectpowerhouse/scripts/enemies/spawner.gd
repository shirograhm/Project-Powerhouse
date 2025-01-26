class_name spawner extends Path2D

@onready var wave_timer := $WaveTimer

@export var wave_number := 0
@export var spawn_time := 1.0
@export var spawn_parent: Node2D
@export var player_node: player
@export var max_wave := 9

var time_since_spawn := 0.0
var set_wave_state := wave_state.WAVE
var enemies_deleted := false

enum wave_state {WAVE, BREAK}

var total_size:float;

func _ready() -> void:
	if (curve == null || curve.point_count <= 0):
		printerr("NO CURVE ASSIGNED TO SPAWNER. FIX IT FIX IT FIX IT")
		set_process(false)
		return
	var prev := curve.get_point_position(0)
	for i in range(1, curve.point_count):
		var point = curve.get_point_position(i)
		total_size += prev.distance_to(point)
		prev = point
		
	print("Starting first wave..")
	wave_timer.start(Global.WAVE_TIME)

func _process(delta: float) -> void:
	if player_node.is_dead:
		if spawn_parent:
			spawn_parent.queue_free()
			spawn_parent = null
	else:
		spawn_waves()

func _physics_process(delta: float) -> void:
	time_since_spawn += delta;

func spawn_waves():
	if set_wave_state == wave_state.WAVE:
		if (time_since_spawn >= spawn_time):
			time_since_spawn = 0;
			spawn();
	else:
		if !enemies_deleted:
			for node in spawn_parent.get_children():
				if node.is_in_group(Global.GROUP_ENEMIES):
					node.queue_free()
			enemies_deleted = true

func spawn():
		
	var weights:PackedFloat32Array
	for i in range(ResourceManager.spawnables.size()):
		var weight = 0;
		if (ResourceManager.spawnables[i].wave_number <= wave_number):
			weight = ResourceManager.spawnables[i].spawn_chance;
		weights.append(weight)
	
	var index = Global.rng.rand_weighted(weights)
	
	var instance = ResourceManager.spawnables[index].spawn_scene.instantiate() as enemy_base;
	var ratio = randf() * total_size
	var length := 0.0;
	var prev := curve.get_point_position(0)
	for i in range(1, curve.point_count):
		var next = curve.get_point_position(i)
		var prevLength = length
		length += prev.distance_to(next)
		if (length >= ratio):
			var dir = prev.direction_to(next)
			instance.position = prev + (length - ratio) * dir
			spawn_parent.add_child(instance)
			instance.init(player_node)
			print("Spawned " + instance.name + " at " + str(instance.position))
			return
		prev = next
	
func increment_wave():
	wave_number += 1
	print("Starting wave #" + str(wave_number))

func get_wave_hud_values():
	if set_wave_state == wave_state.WAVE:
		return Vector3(wave_number, Global.WAVE_TIME, wave_timer.time_left)
	else:
		return Vector3(wave_number, Global.WAVE_BREAK_TIME, wave_timer.time_left)

func _on_wave_timer_timeout() -> void:
	if set_wave_state == wave_state.WAVE:
		set_wave_state = wave_state.BREAK
		wave_timer.start(Global.WAVE_BREAK_TIME)
		player_node.show_inventory()
		print("Start wave break after wave #" + str(wave_number))
	else:
		set_wave_state = wave_state.WAVE
		increment_wave()
		player_node.hide_inventory()
		wave_timer.start(Global.WAVE_TIME)
		
	
	
