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
var evolution_ready: bool = false
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
var benched: bool = false
var poison_condition: poison_type = poison_type.NONE
var burn_condition: burn_type = burn_type.NONE
var turn_condition: turn_type = turn_type.NONE
var imprison: bool = false
var shockwave: bool = false
#endregion
#--------------------------------------
var readied: bool = false

func _ready():
	type = pokedata.type
	weak = pokedata.weak
	resist = pokedata.resist
	readied = true

#--------------------------------------
#region DAMAGE HANDLERS
func should_ko() -> bool:
	return (pokedata.HP - damage_counters) < 0

func add_damage(_base_ammount) -> int:
	return 0

func bench_add_damage(_ammount) -> int:
	return 0
#endregion
#--------------------------------------

#--------------------------------------
#region ENERGY HANDLERS
func add_energy(energy_card: Base_Card) -> void: #VERY UNFINISHED
	energy_cards.append(energy_card)
	print(count_energy())

func energy_removal(removing_type: String) -> void:
	print("How to remove ", removing_type)
	count_energy()

func count_energy() -> Dictionary:
	#Count if energy cars provided give the right energy for each attack
	#Each attackm will be treated differently
	#EG: Double magma will provide two dark for one attack but two fighting for another
	#It depends on which combination satisfies the cost
	print(current_card.name,"'s energy")
	var attached_energy: Dictionary = {"Grass": 0, "Fire": 0, "Water": 0,
 	"Lightning": 0, "Psychic":0, "Darkness":0, "Metal":0, "Colorless":0,
 	"Rainbow":0, "Magma":0, "Aqua":0, "Dark Metal":0, "React": 0,
 	"Holon FF": 0, "Holon GL": 0, "Holon WP": 0}
	var energy_array: Array[String] = []
	for card in energy_cards:
		var energy_string: String = card.energy_properties.how_display()
		print(energy_string)
		attached_energy[energy_string] += 1
		energy_array.append(energy_string)
	
	current_slot.display_energy(energy_array, attached_energy)
	return attached_energy

#endregion
#--------------------------------------

#--------------------------------------
#region OTHER ATTATCHMENTS
func can_evolve_into(evolution: Base_Card) -> bool:
	return current_card.name == evolution.pokemon_properties.evolves_from

func evolve_card(evolution: Base_Card) -> void:
	evolved_from.append(current_card)
	current_card = evolution
	refresh()

func attatch_tool(new_tool: Base_Card):
	if not tool_card:
		tool_card = new_tool
	else:
		push_error(current_card.name, " already has tool attatched")
	refresh()

func remove_tool():
	tool_card = null
	refresh()

func attatch_tm(new_tm: Base_Card):
	tm_cards.push_front(new_tm)
	print("TMS: ",tm_cards)
	refresh()

func remove_tms():
	tm_cards.clear()
	refresh()

#endregion
#--------------------------------------

#--------------------------------------
#region CONDITION HANDLERS
func add_condition(condition: String, severe: bool = false) -> void:
	match condition:
		"Poison":
			add_poison(severe)
		"Burn":
			add_burn(severe)
		"Imprison":
			set_imprison(true)
		"Shockwave":
			set_shockwave(true)
		_:
			add_turn(condition)
	refresh()

func add_poison(severe: bool = false) -> void:
	if not benched:
		poison_condition = poison_type.HEAVY if severe else poison_type.NORMAL
	else:
		print(current_card.name)
		push_error("Adding Poision to a benched mon")

func add_burn(severe: bool = false) -> void:
	if not benched:
		burn_condition = burn_type.HEAVY if severe else burn_type.NORMAL
	else:
		push_error("Adding Poision to a benched mon")

func add_turn(which) -> void:
	if not benched:
		match which:
			"Paralysis":
				turn_condition = turn_type.PARALYSIS
			"Asleep":
				turn_condition = turn_type.ASLEEP
			"Confusion":
				turn_condition = turn_type.CONFUSION
			_:
				push_error("add_turn can't add ", which)

func set_imprison(result: bool) -> void:
	imprison = result
	refresh()

func set_shockwave(result: bool) -> void:
	shockwave = result
	refresh()

func affected_by_condition() -> bool:
	var poisioned: bool = poison_condition != poison_type.NONE
	var burnt: bool = burn_condition != burn_type.NONE
	var turnt: bool = turn_condition != turn_type.NONE
	
	return poisioned or burnt or turnt

func heal_status() -> void:
	poison_condition = poison_type.NONE
	burn_condition = burn_type.NONE
	turn_condition = turn_type.NONE
	refresh()

#endregion
#--------------------------------------

#--------------------------------------
#MANAGING DISPLAYS
func slot_into(destination: UI_Slot):
	current_slot = destination
	refresh()

func refresh() -> void:
	if not readied: return
	
	pokedata = current_card.pokemon_properties
	print(current_card.image, current_slot.art)
	#Change slot's card display
	current_slot.art.texture = current_card.image
	current_slot.name_section.clear()
	current_slot.name_section.append_text(current_card.name)
	current_slot.max_hp.clear()
	current_slot.max_hp.append_text(str("HP: ",pokedata.HP - damage_counters, "/", pokedata.HP))
	current_slot.display_types(pokedata.type_flags_to_array(pokedata.type))
	#recognize position of slot
	benched = not current_slot.active
	current_slot.connected_card = self
	
	#check for any attatched cards/conditions
	current_slot.display_condition()
	current_slot.display_imprision(imprison)
	current_slot.display_shockwave(shockwave)
	
	if tm_cards.size():
		current_slot.tm.texture = tm_cards[0].image
		current_slot.tm.show()
	else: current_slot.tm.hide()
	if tool_card:
		current_slot.tool.show()
		current_slot.tool.texture = tool_card.image
	else: current_slot.tool.hide()

#endregion
#--------------------------------------
