@icon("res://Art/ExpansionIcons/40px-SetSymbolFireRed_and_LeafGreen.png")
extends Resource
class_name PokeSlot

#--------------------------------------
#region VARIABLES
#--------------------------------------
#region BASIC
@export var current_card: Base_Card
@export var damage_counters: int = 0
#endregion
#--------------------------------------
#--------------------------------------
#region NON EXPORT
var ui_slot: UI_Slot
var in_attacking_turn: bool = true
var current_attack: Attack
var attached_energy: Dictionary = {"Grass": 0, "Fire": 0, "Water": 0,
	"Lightning": 0, "Psychic":0, "Fighting":0 ,"Darkness":0, "Metal":0,
	"Colorless":0, "Magma":0, "Aqua":0, "Dark Metal":0, "React": 0, 
	"Holon FF": 0, "Holon GL": 0, "Holon WP": 0, "Rainbow":0}

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
@export var energy_cards: Array[Base_Card] = []
@export var tm_cards: Array[Base_Card] = []
@export var tool_card: Base_Card
@export var applied_buffs: Array[Buff] = []
@export var applied_disable: Array[Disable] = []
@export var applied_condition: Condition = Condition.new()
#endregion
#--------------------------------------
#--------------------------------------
#region TYPE VARIABLES
@export_group("Type")
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

#endregion
#--------------------------------------

#--------------------------------------
#region CHECKUP & POWER/BODY
func pokemon_checkup() -> void:
	evolved_this_turn = false
	evolution_ready = true
	
	if applied_condition.mutually_exclusive_conditions == turn_type.PARALYSIS:
		applied_condition.mutually_exclusive_conditions = turn_type.NONE

func action_checkup(action: String):
	var targets = get_targets(self, [])
	Globals.fundies.record_source_target(ui_slot.home, targets[0], targets[1])
	check_power_body(action)

func check_power_body(action: String):
	print("Check ", current_card.name, "'s power/body after ", action)
	Globals.fundies.remove_top_source_target()

#endregion
#--------------------------------------

#--------------------------------------
#region HELPERS
func is_in_slot(desired_side: Constants.SIDES, desired_slot: Constants.SLOTS) -> bool:
	var side_bool: bool = false
	var slot_bool: bool = false
	
	if not is_filled(): return false
	
	match desired_side:
		#var fund: Fundies = Globals.fundies
		Constants.SIDES.BOTH:
			side_bool = true
		Constants.SIDES.ATTACKING:
			side_bool = is_attacker()
		Constants.SIDES.DEFENDING:
			side_bool = not is_attacker()
		Constants.SIDES.SOURCE:
			side_bool = Globals.fundies.get_source_considered() == ui_slot.home
		Constants.SIDES.OTHER:
			side_bool = not Globals.fundies.get_source_considered() == ui_slot.home
	
	match desired_slot:
		Constants.SLOTS.ALL:
			slot_bool = true
		Constants.SLOTS.ACTIVE:
			slot_bool = is_active()
		Constants.SLOTS.BENCH:
			slot_bool = not is_active()
		Constants.SLOTS.TARGET:
			slot_bool = Globals.fundies.get_targets().has(self)
		Constants.SLOTS.REST:
			slot_bool = not Globals.fundies.get_targets().has(self)
	
	return slot_bool and side_bool

func is_filled() -> bool:
	return current_card != null

func is_active() -> bool:
	if ui_slot:
		return ui_slot.active
	else:
		return false

func is_home() -> bool:
	return ui_slot.home

func is_attacker() -> bool:
	return ui_slot.home == Globals.fundies.home_turn

func can_evolve_into(evolution: Base_Card) -> bool:
	return current_card.name == evolution.pokemon_properties.evolves_from and not evolved_this_turn

func can_devolve() -> bool:
	return evolved_from.size()

func get_targets(atk: PokeSlot, def: Array[PokeSlot]) -> Array[Array]:
	var targets: Array[Array] = [[],[]]
	
	if atk.ui_slot.home:
		targets[0].append(atk)
		targets[1] = def
	else:
		targets[1].append(atk)
		targets[0] = def
	
	return targets

func get_pokedata() -> Pokemon:
	return current_card.pokemon_properties

#endregion
#--------------------------------------

#--------------------------------------
#region SLOTTING IN
func use_card(card: Base_Card) -> void:
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
		add_energy(card)
	else:
		printerr("You probably can't pay ", card, " on a pokeslot ", card_type)

func set_card(card: Base_Card) -> void:
	current_card = card
	ui_slot.make_allowed(true)
	action_checkup("Set")

func return_card() -> void:
	pass
#endregion
#--------------------------------------

#--------------------------------------
#region DAMAGE HANDLERS
func should_ko() -> bool:
	return (get_pokedata().HP - damage_counters) < 0

func add_damage(_base_ammount) -> int:
	return 0

func bench_add_damage(_ammount) -> int:
	return 0
#endregion
#--------------------------------------

#--------------------------------------
#region ENERGY HANDLERS
func add_energy(energy_card: Base_Card):
	var energy_string: String = energy_card.energy_properties.get_current_string()
	energy_cards.append(energy_card)
	energy_card.energy_properties.attatched_to = self
	refresh()
	action_checkup(str("EN ", energy_string))

func remove_energy(en_name: String):
	for card in energy_cards:
		if card.name == en_name:
			energy_cards.erase(card)
			refresh()
			return
	
	printerr("Couldn't find ", en_name, " in array ", energy_cards)

func count_energy() -> void:
	#Count if energy cars provided give the right energy for each attack
	#Each attackm will be treated differently
	#EG: Double magma will provide two dark for one attack but two fighting for another
	#It depends on which combination satisfies the cost
	attached_energy = {"Grass": 0, "Fire": 0, "Water": 0,
	 "Lightning": 0, "Psychic":0, "Fighting":0 ,"Darkness":0, "Metal":0,
	 "Colorless":0, "Magma":0, "Aqua":0, "Dark Metal":0, "React": 0, 
	 "FF": 0, "GL": 0, "WP": 0, "Rainbow":0}
	
	for energy in energy_cards:
		print(energy)
		if energy.energy_properties.attatched_to != self:
			energy.energy_properties.attatched_to = self
		var en_provide: EnData = energy.energy_properties.get_current_provide()
		var en_name: String = en_provide.get_string()
		attached_energy[en_name] += en_provide.number
	
	#print(attached_energy)

func get_energy_strings() -> Array[String]:
	var energy_stirngs: Array[String]
	
	for card in energy_cards:
		var en_name = card.energy_properties.get_current_string()
		energy_stirngs.append(en_name)
	
	print_verbose("BEFORE SORT: ", energy_stirngs)
	
	energy_stirngs.sort_custom(func(a,b): #Basic + Darkness + Metal has highest priority
		return Constants.energy_types.find(a) < Constants.energy_types.find(b))
	print_verbose("AFTER: ", energy_stirngs)
	
	return energy_stirngs

func count_diff_energy() -> int:
	var diff: int = 0
	var recorded: Array[String] = []
	for card in energy_cards:
		if not(card.name in recorded):
			diff += 1
			recorded.append(card.name)
	
	return diff

##If true this function return basic energy otherwise, special
func get_energy_considered(basic: bool = true):
	var final_array: Array[Base_Card]
	
	for card in energy_cards:
		if (card.energy_properties.considered == "Basic Energy") == basic:
			final_array.append(card)
	
	return final_array

func get_total_energy(enData_filter: EnData = null, filtered_array: Array[Base_Card] = []) -> int:
	var total: int = 0
	var using: Array[Base_Card] = filtered_array if filtered_array.size() != 0 else energy_cards
	var skip_enData: bool = enData_filter == null or enData_filter.get_string() == "Rainbow"
	
	for card in using:
		var en_provide: EnData = card.energy_properties.get_current_provide()
		var add: bool = skip_enData or (en_provide.same_type(enData_filter))
		if add:
			total += en_provide.number
	
	return total

#When provides don't matter
func get_total_en_categories(category_filter: String = "Any") -> Array[Base_Card]:
	var final: Array[Base_Card]
	var skip_category: bool = category_filter == "Any"
	for card in energy_cards:
		if skip_category or card.energy_properties.considered == category_filter:
			final.append(card)
	return final

func get_energy_excess() -> int:
	var test_attack: Attack = current_card.pokemon_properties.attacks[-1]
	return get_total_energy() + test_attack.pay_cost(self)

#endregion
#--------------------------------------

#--------------------------------------
#region OTHER ATTATCHMENTS
func evolve_card(evolution: Base_Card) -> void:
	evolved_from.append(current_card)
	current_card = evolution
	refresh()
	action_checkup("Evo")

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
	action_checkup("Tool")

func remove_tool() -> void:
	tool_card = null
	refresh()

func attatch_tm(new_tm: Base_Card) -> void:
	tm_cards.push_front(new_tm)
	print("TMS: ",tm_cards)
	refresh()
	action_checkup("TM")

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
	if not is_active():
		applied_condition.poison = poison_type.HEAVY if severe else poison_type.NORMAL
	else:
		print(current_card.name)
		push_error("Adding Poision to a benched mon")

func add_burn(severe: bool = false) -> void:
	if not is_active():
		applied_condition.burn = burn_type.HEAVY if severe else burn_type.NORMAL
	else:
		push_error("Adding Poision to a benched mon")

func add_turn(which) -> void:
	if not is_active():
		match which:
			"Paralysis":
				applied_condition.mutually_exclusive_conditions = turn_type.PARALYSIS
			"Asleep":
				applied_condition.mutually_exclusive_conditions = turn_type.ASLEEP
			"Confusion":
				applied_condition.mutually_exclusive_conditions = turn_type.CONFUSION
			_:
				push_error("add_turn can't add ", which)

func set_imprison(result: bool) -> void:
	applied_condition.imprison = result
	refresh()

func set_shockwave(result: bool) -> void:
	applied_condition.shockwave = result
	refresh()

func affected_by_condition() -> bool:
	var poisioned: bool = applied_condition.poison != poison_type.NONE
	var burnt: bool = applied_condition.burn != burn_type.NONE
	var turnt: bool = applied_condition.mutually_exclusive_conditions != turn_type.NONE
	
	return poisioned or burnt or turnt

func heal_status() -> void:
	applied_condition.poison = poison_type.NONE
	applied_condition.burn = burn_type.NONE
	applied_condition.mutually_exclusive_conditions = turn_type.NONE
	refresh()

#endregion
#--------------------------------------

#--------------------------------------
#region MANAGING DISPLAYS
func slot_into(destination: UI_Slot):
	ui_slot = destination
	refresh()

func refresh() -> void:
	#Change slot's card display
	ui_slot.name_section.clear()
	ui_slot.max_hp.clear()
	
	if current_card:
		ui_slot.display_image(current_card)
		ui_slot.name_section.append_text(current_card.name)
		ui_slot.max_hp.append_text(str("HP: ",get_pokedata().HP - damage_counters, "/", get_pokedata().HP))
		ui_slot.display_types(Conversions.flags_to_type_array(get_pokedata().type))
	else:
		ui_slot.display_image(null)
		ui_slot.display_types([])
	
	#recognize position of slot
	ui_slot.connected_slot = self
	
	#check for any attatched cards/conditions
	count_energy()
	ui_slot.display_energy(get_energy_strings(), attached_energy)
	ui_slot.display_condition()
	ui_slot.display_imprision(applied_condition.addable_effects & 1)
	ui_slot.display_shockwave(applied_condition.addable_effects & 2)
	
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
