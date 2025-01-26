extends Node

@export var player_path:NodePath
@export var spawner_path:NodePath

@onready var health_label = $HUDPanel/HealthBar/HealthLabel
@onready var health_bar   = $HUDPanel/HealthBar
@onready var wave_label   = $HUDPanel/WaveLabel
@onready var wave_bar     = $HUDPanel/WaveBar

var player_node: player
var spawner_node: spawner

func _ready() -> void:
	player_node = get_node(player_path) as player
	spawner_node = get_node(spawner_path) as spawner
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
	
	var waves_values = spawner_node.get_wave_hud_values()
	wave_bar.min_value = 0
	wave_bar.max_value = waves_values.y
	wave_bar.value = waves_values.y - waves_values.z
	# Note wave + 1 so player doesnt start at wave 0
	wave_label.text = "Wave " + str(waves_values.x + 1)
