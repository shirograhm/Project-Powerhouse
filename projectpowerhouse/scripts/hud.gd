extends Node

@export var player_path:NodePath

var player_node: player

func _ready() -> void:
	player_node = get_node(player_path) as player

func _process(delta: float) -> void:
	update_HUD_values()

func update_HUD_values() -> void:
	$'HUDPanel/HealthBar/HealthLabela'.text = "[center]" + str(player_node.health) + " out of " + str(player_node.max_health)
	$HUDPanel/HealthBar.min_value = 0
	$HUDPanel/HealthBar.max_value = player_node.max_health
	$HUDPanel/HealthBar.value = player_node.health
	# TODO: Once we have a wave timer, we can do this
	# $HUDPanel/WaveBar.min_value = 0
	# $HUDPanel/WaveBar.max_value = GLOBAL_VAR.WAVE_DURATION
	# $HUDPanel/WaveBar.value = GLOBAL_VAR.WAVE_DURATION - game_scene.wave_timer.time_left
	# TODO: Once we have a wave counter, we can do this
	# $HUDPanel/WaveLabel.text = "Wave " + str(game_scene.current_wave)
