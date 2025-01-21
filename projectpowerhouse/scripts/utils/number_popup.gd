extends Node2D


@onready var crit_icon = preload("res://texures/crit_icon.png")

@onready var life_timer = $LifeTimer
@onready var text_label = $RichTextLabel

const LIFETIME = 1.1
const SPEED = 4

var is_crit = false
var direction = Vector2.ONE

var text_color = Color.ANTIQUE_WHITE
var text_info = ""

func _ready() -> void:
	self.position += Vector2(Global.rng.randf() * 5, Global.rng.randf() * 5)
	text_label.add_theme_font_override("normal_font", Global.GAME_FONT)
	text_label.add_theme_font_size_override("normal_font_size", Global.GAME_FONT_SIZE)
	text_label.text = ""
	if is_crit:
		text_label.add_image(crit_icon, Global.GAME_FONT_SIZE, Global.GAME_FONT_SIZE)
	text_label.push_color(self.text_color)
	text_label.append_text(text_info)
	life_timer.start(LIFETIME)


func _process(delta: float) -> void:
	var direction = Vector2(Global.rng.randf() * 3, -1)
	position += direction.normalized() * SPEED * delta


func set_parameters(value: float, num_type: Global.NumberType, crit: bool = false) -> void:
	is_crit = crit
	match num_type:
		Global.NumberType.DAMAGE:
			self.text_color = Global.DAMAGE_NUM_COLOR
		Global.NumberType.HEALING:
			self.text_color = Global.HEAL_NUM_COLOR
	self.text_info = str(value)

func _on_life_timer_timeout() -> void:
	queue_free()
