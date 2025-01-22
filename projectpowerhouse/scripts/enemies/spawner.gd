extends Path2D

@export var wave_number := 0
@export var spawn_time := 1.0
@export var spawn_parent: Node2D
@export var player_node: player

var time_since_spawn := 0.0

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

func _process(delta: float) -> void:
	if player_node.is_dead:
		if spawn_parent:
			spawn_parent.queue_free()
			spawn_parent = null
	else:
		if (time_since_spawn >= spawn_time):
			time_since_spawn = 0;
			spawn();

func _physics_process(delta: float) -> void:
	time_since_spawn += delta;


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
	
