extends Node
class_name PokeSlot

@export var current_card: Base_Card
@export var current_slot: UI_Slot

@export_group("Temp Types")
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 0
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var weak: int = 0
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var resist: int = 0

@onready var pokedata: Pokemon = current_card.pokemon_properties

enum poison_type{NONE, NORMAL, HEAVY}
enum burn_type{NONE, NORMAL, HEAVY}
enum turn_type{NONE, PARALYSIS, ASLEEP, CONFUSION}

#signal refresh()

#--------------------------------------
#region ATTATCHED VARIABLES
var evolved_from: Array[Base_Card] = [] #
var energy_cards: Array[Base_Card] = []
var tm_cards: Array[Base_Card] = []
var tool_card: Base_Card
#endregion
#--------------------------------------
#--------------------------------------
#region TYPE VARIABLES
var use_weakness: bool = true
var use_resistance: bool = true
#endregion
#--------------------------------------
#--------------------------------------
#region BUFF/DEBUFF VARIABLES
var attack_buff: int = 0
var defense_buff: int = 0
var ex_immune: bool = false

#endregion
#--------------------------------------
#--------------------------------------
#region ALLOWANCES VARIABLES
var use_body: bool = true
var use_power: bool = false
var use_attack: bool = true
#endregion
#--------------------------------------
#--------------------------------------
#region CONDITION VARIABLES
var damage_counters: int = 0
var poison_condition: poison_type = poison_type.NONE
var burn_condition: burn_type = burn_type.NONE
var turn_condition: turn_type = turn_type.NONE
var imprison: bool = false
var shockwave: bool = false
#endregion
#--------------------------------------

func should_ko() -> bool:
	return (pokedata.HP - damage_counters) < 0

func add_damage(ammount) -> int:
	return 0

func bench_add_damage(ammount) -> int:
	return 0

#--------------------------------------
#region CONDITION HANDLERS
func add_poison(severity):
	match severity:
		"Normal":
			poison_condition = poison_type.NORMAL
		"Heavy":
			poison_condition = poison_type.HEAVY
	#refresh.emit()

func add_burn(severity):
	match severity:
		"Normal":
			burn_condition = burn_type.NORMAL
		"Heavy":
			burn_condition = burn_type.HEAVY
	#refresh.emit()

func add_turn(which):
	match which:
		"Paralysis":
			turn_condition = turn_type.PARALYSIS
		"Asleep":
			turn_condition = turn_type.ASLEEP
		"Confusion":
			turn_condition = turn_type.CONFUSION
	#refresh.emit()

func heal_status():
	poison_condition = poison_type.NONE
	burn_condition = burn_type.NONE
	turn_condition = turn_type.NONE
	#refresh.emit()

#endregion
#--------------------------------------

func refresh():
	current_slot.art.texture = current_card.image
	current_slot.name_section.clear()
	current_slot.name_section.append_text(current_card.name)
	current_slot.max_hp.clear()
	current_slot.max_hp.append_text(str("MAX HP: ",pokedata.HP - damage_counters, "/", pokedata.HP))
	current_slot.tool.texture = tool_card.image
	current_slot.display_types(pokedata.type_flags_to_array(pokedata.type))
	
	if shockwave: current_slot.shockwave.show()
	if imprison: current_slot.imprison.show()
	

