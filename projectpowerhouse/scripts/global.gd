extends Node

var rng := RandomNumberGenerator.new()

# Global data any class could use
const GAME_FONT = preload("res://texures/SuperChips.ttf")
const GAME_FONT_SIZE = 24.0
const DURABILITY_MAX =  0.4
const MIN_DAMAGE_CAP =  1.0

# Number Popup Constants
const NUMBER_POPUP_PREFAB = preload("res://scenes/utils/number_popup.tscn")
enum NumberType {
	DAMAGE, HEALING
}
const DAMAGE_NUM_COLOR = Color.INDIAN_RED
const HEAL_NUM_COLOR   = Color.LIME_GREEN

# Player Constants
const BASE_MAX_HEALTH  =  50.0
const BASE_ATTACK_SPD  =   0.9  # attacks per second
const BASE_CRIT_CHANCE =   0.5	# 50% base crit chance
const BASE_CRIT_DAMAGE =   1.6	# 60% bonus damage on crits
const BASE_MOVE_SPEED  = 200.0
const ATTACK_DELAY = 0.8
const IFRAME_DELAY = 0.2

# Wave Constants
const WAVE_TIME = 15.0
const WAVE_BREAK_TIME = 5.0

func _ready() -> void:
	pass

## Durability is capped at 40% and reduces the damage first before armor is calculated
## Defence reduces a flat amount of damage. This is applied after durability
## Function:
## 		damage = incoming * (1 - durability) - defense
##		damage cannot be reduced below MIN_DAMAGE_CAP
static func get_mitigation(defense_in: float, durability_in: float, damage_in: float) -> float:
	durability_in = min(durability_in, DURABILITY_MAX)
	var after_calc = max(damage_in * (1 - durability_in) - defense_in, MIN_DAMAGE_CAP)
	return after_calc
		
static func spawn_number_popup(value: float, num_type: Global.NumberType, is_crit: bool, affected_node: Node2D) -> void:
	print("spawned number popup")
	var number_obj = NUMBER_POPUP_PREFAB.instantiate()
	number_obj.set_position(affected_node.position)
	number_obj.set_parameters(value, num_type, is_crit)
	affected_node.add_sibling(number_obj)
