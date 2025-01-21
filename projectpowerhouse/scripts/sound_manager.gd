extends Node

@export var pitch_range := Vector2(0.8, 1.2)

@onready var _shotgun_shoot = $ShotgunShoot
@onready var _boo_woo_woo = $Booowooowooo
@onready var _item_pickup = $ItemPickup

enum sound_effect {SHOTGUN_SHOOT, BOO_WOO_WOO, ITEM_PICKUP}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func play_sound(type: sound_effect):
	if type == sound_effect.SHOTGUN_SHOOT:
		_shotgun_shoot.pitch_scale = Global.rng.randf_range(pitch_range.x, pitch_range.y)
		_shotgun_shoot.play()
	elif type == sound_effect.BOO_WOO_WOO:
		_boo_woo_woo.pitch_scale = Global.rng.randf_range(pitch_range.x, pitch_range.y)
		_boo_woo_woo.play()
	elif type == sound_effect.ITEM_PICKUP:
		_item_pickup.pitch_scale = Global.rng.randf_range(pitch_range.x, pitch_range.y)
		_item_pickup.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
