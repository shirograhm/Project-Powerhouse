extends Node

@export var player_path:NodePath

@onready var health_label = $HUDPanel/HealthBar/HealthLabel
@onready var health_bar   = $HUDPanel/HealthBar
@onready var wave_label   = $HUDPanel/WaveLabel
@onready var wave_bar     = $HUDPanel/WaveBar

var player_node: player

func _ready() -> void:
	player_node = get_node(player_path) as player
	health_label.add_theme_font_override("normal_font", Global.GAME_FONT)
	health_label.add_theme_font_size_override("normal_font_size", Global.GAME_FONT_SIZE)
	wave_label.add_theme_font_override("normal_font", Global.GAME_FONT)
	wave_label.add_theme_font_size_override("normal_font_size", Global.GAME_FONT_SIZE)

func _process(delta: float) -> void:
	update_HUD_values()

func update_HUD_values() -> void:
	health_label.text = "[center]" + str(player_node.health) + " / " + str(player_node.max_health)
	health_bar.min_value = 0
	health_bar.max_value = player_node.max_health
	health_bar.value = player_node.health
	# TODO: Once we have a wave timer, we can do this
	# wave_bar.min_value = 0
	# wave_bar.max_value = GLOBAL_VAR.WAVE_DURATION
	# wave_bar.value = GLOBAL_VAR.WAVE_DURATION - game_scene.wave_timer.time_left
	# TODO: Once we have a wave counter, we can do this
	# wave_label.text = "Wave " + str(game_scene.current_wave)
