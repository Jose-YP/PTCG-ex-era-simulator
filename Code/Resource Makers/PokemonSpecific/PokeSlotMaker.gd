@icon("res://Art/ExpansionIcons/40px-SetSymbolFireRed_and_LeafGreen.png")
extends Resource
class_name PokeSlotRes

#--------------------------------------
#region VARIABLES
#--------------------------------------
#region LOCATION
@export var player_type: Constants.PLAYER_TYPES
@export var side: Constants.SIDES
@export var slot: Constants.SLOTS
@export var current_card: Base_Card
#endregion
#--------------------------------------
#--------------------------------------
#region NON EXPORT
var ui_slot: UI_Slot
var pokedata: Pokemon = current_card.pokemon_properties if current_card else null
var fundies: Fundies

enum poison_type{NONE, NORMAL, HEAVY}
enum burn_type{NONE, NORMAL, HEAVY}
enum turn_type{NONE, PARALYSIS, ASLEEP, CONFUSION}
#endregion
#--------------------------------------
#--------------------------------------
#region ATTATCHED VARIABLES
@export_group("Attatchments")
@export var evolution_ready: bool = false
@export var evolved_this_turn: bool = false
@export var evolved_from: Array[Base_Card] = [] #
@export var energy_array: Array[String] = []
@export var attached_energy: Dictionary = {"Grass": 0, "Fire": 0, "Water": 0,
	"Lightning": 0, "Psychic":0, "Fighting":0 ,"Darkness":0, "Metal":0,
	"Colorless":0, "Magma":0, "Aqua":0, "Dark Metal":0, "React": 0, 
	"Holon FF": 0, "Holon GL": 0, "Holon WP": 0, "Rainbow":0}
@export var tm_cards: Array[Base_Card] = []
@export var tool_card: Base_Card
#endregion
#--------------------------------------
#--------------------------------------
#region TYPE VARIABLES
@export_group("Type")
@export var use_weakness: bool = true
@export var use_resistance: bool = true

@export_subgroup("Temp Types")
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 0
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var weak: int = 0
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var resist: int = 0
#endregion
#--------------------------------------
#--------------------------------------
#region BUFF/DEBUFF VARIABLES
@export_group("Buffs")
@export var attack_buff: int = 0
@export var defense_buff: int = 0

#endregion
#--------------------------------------
#--------------------------------------
#region ALLOWANCES VARIABLES
@export_group("Allowances")
@export var use_body: bool = true
@export var ex_immune: bool = false
@export var use_power: bool = false
@export var use_attack: bool = true
@export var in_attacking_turn: bool = true
#endregion
#--------------------------------------
#--------------------------------------
#region CONDITION VARIABLES
@export_group("Condition")
@export var damage_counters: int = 0
@export var benched: bool = false
@export var poison_condition: poison_type = poison_type.NONE
@export var burn_condition: burn_type = burn_type.NONE
@export var turn_condition: turn_type = turn_type.NONE
@export var imprison: bool = false
@export var shockwave: bool = false
#endregion
#--------------------------------------
@export var readied: bool = false
@export var knocked_out: bool = false
@export var is_target: bool = false
#endregion
#--------------------------------------

func _ready():
	if current_card:
		type = pokedata.type
		weak = pokedata.weak
		resist = pokedata.resist
	readied = true

func pokemon_checkup():
	evolved_this_turn = false
	evolution_ready = true
	
	if turn_condition == turn_type.PARALYSIS:
		turn_condition = turn_type.NONE

func is_in_slot(desired_side: Constants.SIDES, desired_slot: Constants.SLOTS):
	var side_bool: bool = false
	var slot_bool: bool = false
	
	match desired_side:
		Constants.SIDES.BOTH:
			side_bool = true
		Constants.SIDES.ATTACKING:
			side_bool = in_attacking_turn
		Constants.SIDES.DEFENDING:
			side_bool = not in_attacking_turn
		Constants.SIDES.SOURCE:
			side_bool = fundies.get_source_considered() == player_type
		Constants.SIDES.OTHER:
			side_bool = not fundies.get_source_considered() == player_type
	
	match desired_slot:
		Constants.SLOTS.ALL:
			slot_bool = true
		Constants.SLOTS.ACTIVE:
			slot_bool = is_active()
		Constants.SLOTS.BENCH:
			slot_bool = not is_active()
		Constants.SLOTS.TARGET:
			var targets: Array[PokeSlot] = fundies.get_targets()
			slot_bool = targets.has(self)
	
	return slot_bool and side_bool

func is_active() -> bool:
	if ui_slot:
		return ui_slot.active
	else:
		return false

func is_player() -> bool:
	if ui_slot:
		return ui_slot.player
	else:
		push_error("Not connected to a UI slot")
		return false

func use_card(card: Base_Card):
	var card_type: int = Conversions.get_card_flags(card)
	#Play fossils, basics and evolutions onto the bench
	if card_type & 1 != 0 or card_type & 256 != 0:
		set_card(card)
	elif card_type & 2 != 0:
		if current_card:
			evolve_card(card)
		else:
			set_card(card)
	elif card_type & 32 != 0:
		attatch_tool(card)
	elif card_type & 64 != 0:
		attatch_tm(card)
	#play energy onto any pokemon defined by placement
	elif card_type & 512 != 0:
		change_energy(card)
	else:
		printerr("You probably can't pay ", card, " on a pokeslot ", card_type)

func set_card(card: Base_Card):
	current_card = card
	ui_slot.make_allowed(true)

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
func change_energy(energy_card: Base_Card, ammount: int = 1) -> void: #VERY UNFINISHED
	#Count energy cards, count number later
	var energy_string: String = energy_card.energy_properties.how_display()
	attached_energy[energy_string] += ammount
	if attached_energy[energy_string] < 0: attached_energy[energy_string] = 0
	print(attached_energy, energy_array)
	count_energy()
	refresh()

func count_energy() -> void:
	#Count if energy cars provided give the right energy for each attack
	#Each attackm will be treated differently
	#EG: Double magma will provide two dark for one attack but two fighting for another
	#It depends on which combination satisfies the cost
	print(current_card.name,"'s energy")
	energy_array.clear()
	for card in attached_energy:
		if not attached_energy[card]:
			continue
		for i in range(attached_energy[card]):
			energy_array.append(card)
	
	print("BEFORE SORT: ", energy_array)
	
	energy_array.sort_custom(func(a,b): #Basic + Darkness + Metal has highest priority
		return Constants.energy_types.find(a) < Constants.energy_types.find(b))
	print("AFTER: ", energy_array)

#endregion
#--------------------------------------

#--------------------------------------
#region OTHER ATTATCHMENTS
func can_evolve_into(evolution: Base_Card) -> bool:
	return current_card.name == evolution.pokemon_properties.evolves_from and not evolved_this_turn

func evolve_card(evolution: Base_Card) -> void:
	evolved_from.append(current_card)
	current_card = evolution
	refresh()

func can_devolve() -> bool:
	return evolved_from.size()

func devolve_card() -> Base_Card:
	var old_card: Base_Card = current_card
	current_card = evolved_from.pop_back()
	refresh()
	return old_card

func attatch_tool(new_tool: Base_Card) -> void:
	if not tool_card:
		tool_card = new_tool
	else:
		push_error(current_card.name, " already has tool attatched")
	refresh()

func remove_tool() -> void:
	tool_card = null
	refresh()

func attatch_tm(new_tm: Base_Card) -> void:
	tm_cards.push_front(new_tm)
	print("TMS: ",tm_cards)
	refresh()

func remove_tms() -> void:
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
#region MANAGING DISPLAYS
func slot_into(destination: UI_Slot):
	ui_slot = destination
	refresh()

func refresh() -> void:
	if not readied: return
	
	#Change slot's card display
	ui_slot.name_section.clear()
	ui_slot.max_hp.clear()
	
	if current_card:
		pokedata = current_card.pokemon_properties
		print(current_card.image, ui_slot.art)
		ui_slot.art.texture = current_card.image
		ui_slot.name_section.append_text(current_card.name)
		ui_slot.max_hp.append_text(str("HP: ",pokedata.HP - damage_counters, "/", pokedata.HP))
		ui_slot.display_types(Conversions.flags_to_type_array(pokedata.type))
	else:
		ui_slot.art.texture = null
		ui_slot.display_types([])
	
	#recognize position of slot
	benched = not ui_slot.active
	#ui_slot.connected_card = self
	
	#check for any attatched cards/conditions
	ui_slot.display_energy(energy_array, attached_energy)
	ui_slot.display_condition()
	ui_slot.display_imprision(imprison)
	ui_slot.display_shockwave(shockwave)
	
	if tm_cards.size():
		ui_slot.tm.texture = tm_cards[0].image
		ui_slot.tm.show()
	else: ui_slot.tm.hide()
	if tool_card:
		ui_slot.tool.show()
		ui_slot.tool.texture = tool_card.image
	else: ui_slot.tool.hide()

#endregion
#--------------------------------------
