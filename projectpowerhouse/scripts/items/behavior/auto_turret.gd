extends Node2D

@export var projectile_scene:PackedScene = null
@export var base_speed:float = 1

var item:item_base
var timer:Timer

func _ready() -> void:
	item = get_parent() as item_base
	if (item == null):
		printerr("No item parent for " + name)
		return
	
	item.on_added_to_inv.connect(on_added_to_inv)
	item.on_removed_from_inv.connect(on_removed_from_inv)
	
	timer = $Timer
	timer.autostart = false
	timer.wait_time = base_speed

func on_added_to_inv() -> void:
	timer.autostart = true
	timer.start()

func on_removed_from_inv() -> void:
	timer.autostart = true
	timer.start()

func _on_timer_timeout() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var nearest:enemy_base = null
	var closest_dist = 1000000.0
	for i in range(enemies.size()):
		var enemy = enemies[i] as enemy_base
		var dist = enemy.global_position.distance_to(global_position)
		if (closest_dist > dist):
			closest_dist = dist
			nearest = enemy
	
	if (nearest == null):
		return
	
	SoundManager.play_sound(SoundManager.sound_effect.SHOTGUN_SHOOT)
	var projectile = projectile_scene.instantiate() as projectile_base
	var player_node = get_parent().get_parent().get_parent() as player
	projectile.set_player(player_node)
	# TODO: dont do this
	player_node.get_parent().add_sibling(projectile)
	projectile.global_transform = global_transform
	
	var target = nearest.global_position
	projectile.direction = global_position.direction_to(target)
	projectile.look_at(target)
