class_name antibody extends projectile_base

var collided_enemy:enemy_base = null;

func handle_collision(collided: Node2D):
	if collided is enemy_base:
		collided_enemy = collided as enemy_base
		var critted = player_node.roll_crit()
		if critted:
			damage *= player_node.get_crit_damage()
		collided_enemy.take_damage(damage, critted)
		queue_free()
	else:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	handle_collision(body)



func _on_area_entered(area: Area2D) -> void:
	handle_collision(area)
