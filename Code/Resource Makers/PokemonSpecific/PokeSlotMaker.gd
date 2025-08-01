@icon("res://Art/ExpansionIcons/40px-SetSymbolFireRed_and_LeafGreen.png")
extends Resource
class_name PokeSlot

#--------------------------------------
#region VARIABLES
@export var current_card: Base_Card
@export_range(0,400,10) var max_HP: int = 0
@export_range(0,400,10) var damage_counters: int = 0
#--------------------------------------
#region NON EXPORT
var ui_slot: UI_Slot
var attached_energy: Dictionary = {"Grass": 0, "Fire": 0, "Water": 0,
	"Lightning": 0, "Psychic":0, "Fighting":0 ,"Darkness":0, "Metal":0,
	"Colorless":0, "Magma":0, "Aqua":0, "Dark Metal":0, "React": 0, 
	"Holon FF": 0, "Holon GL": 0, "Holon WP": 0, "Rainbow":0}
var energy_timers: Dictionary = {}
var damage_timers: Array[Dictionary]
var body_exhaust: bool
var power_exhaust: bool
var body_activated: bool
var power_ready: bool
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
@export var buffs: Array[Dictionary]
@export var disables: Array[Dictionary]
@export var applied_condition: Condition = Condition.new()
#endregion
#--------------------------------------
#region HISTORY
@export_group("History")
@export var current_attack: Attack
@export var dealt_damage: int = 0
@export var energy_discarded: int = 0
#endregion
#endregion
#--------------------------------------

#--------------------------------------
#region SIGNALS
@warning_ignore_start("unused_signal")
signal swap(slot: Consts.SLOTS)
signal retreat()

signal take_dmg(attacker: PokeSlot)
signal ko()

signal attatched_tm(card: Base_Card)
signal attatched_tool(card: Base_Card)
signal evolved(slot: PokeSlot)
signal evolving()
signal attatch_en_signal(card: Base_Card)
signal discard_en_signal(card: Base_Card)
signal played(slot: Consts.SLOTS)

signal condition_applied(condition: Condition)

signal attacks(slot: PokeSlot)
signal used_power()
signal checked_up()
#endregion
#--------------------------------------

#--------------------------------------
#region CHECKUP & POWER/BODY
func pokemon_checkup() -> void:
	if not is_filled(): return
	evolved_this_turn = false
	evolution_ready = true
	
	await checkup_conditions()
	
	for card in energy_timers.keys():
		if energy_timers[card] == 0 and not Globals.board_state.debug_unlimit:
			energy_timers.erase(card)
			remove_energy(card)
		else:
			energy_timers[card] -= 1
	
	for dmg_timer in damage_timers:
		dmg_timer["Timer"] -= 1
		if dmg_timer["Timer"] == 0:
			dmg_manip(dmg_timer["Damage"])
		else:
			print(dmg_timer)
	
	refresh()
	
	await ability_emit(checked_up)

func setup_abilities():
	Globals.fundies.record_single_src_trg(self)
	if get_pokedata().pokebody:
		get_pokedata().pokebody.prep_ability()
	if get_pokedata().pokepower:
		get_pokedata().pokepower.prep_ability()
	Globals.fundies.remove_top_source_target()


func disconnect_abilities():
	if get_pokedata().pokebody:
		get_pokedata().pokebody.disconnect_ability()
	if get_pokedata().pokepower:
		get_pokedata().pokepower.disconnect_ability()

func check_power_body():
	var pokedata: Pokemon = get_pokedata()
	Globals.fundies.record_single_src_trg(self)
	#Ability
	print("Check ", current_card.name, "'s power/body")
	if pokedata.pokebody:
		if pokedata.pokebody.passive:
			body_activated = pokedata.pokebody.activate_passive()
			
	if pokedata.pokepower:
		if pokedata.pokepower.passive:
			pokedata.pokepower.activate_passive()
		
		power_ready = pokedata.pokepower.does_press_activate(self)
	
	Globals.fundies.remove_top_source_target()

func use_ability(ability: Ability):
	if get_pokedata().pokepower == ability:
		if ability.how_often == "Once per Mon":
			power_exhaust = true
		elif ability.how_often == "Once per Turn":
			Globals.fundies.used_ability(ability.name)
	
	Globals.fundies.record_single_src_trg(self)
	await ability.activate_ability()
	used_power.emit()
	Globals.fundies.remove_top_source_target()
	
	refresh()

func ability_emit(sig: Signal, param: Variant = null):
	print("Does ", get_card_name(), " have connections in ", sig, "? ", sig.has_connections())
	
	if sig.has_connections():
		Globals.fundies.record_single_src_trg(self)
		sig.emit(param)
		await SignalBus.ability_activated
		Globals.fundies.remove_top_source_target()
		
		refresh()

func occurance_account_for():
	for slot in Globals.full_ui.get_occurance_slots():
		if get_pokedata().pokebody:
			get_pokedata().pokebody.single_prep(self)
		if get_pokedata().pokepower:
			get_pokedata().pokepower.single_prep(self)

func refresh_connections():
	Globals.fundies.record_single_src_trg(self)
	occurance_account_for()
	Globals.fundies.remove_top_source_target()

#endregion
#--------------------------------------

#--------------------------------------
#region HELPERS
func is_in_slot(desired_side: Consts.SIDES, desired_slot: Consts.SLOTS) -> bool:
	var side_bool: bool = false
	var slot_bool: bool = false
	
	if not is_filled(): return false
	
	match desired_side:
		#var fund: Fundies = Globals.fundies
		Consts.SIDES.BOTH:
			side_bool = true
		Consts.SIDES.ATTACKING:
			side_bool = is_attacker()
		Consts.SIDES.DEFENDING:
			side_bool = not is_attacker()
		Consts.SIDES.SOURCE:
			side_bool = Globals.fundies.get_source_considered() == ui_slot.home
		Consts.SIDES.OTHER:
			side_bool = not Globals.fundies.get_source_considered() == ui_slot.home
	
	match desired_slot:
		Consts.SLOTS.ALL:
			slot_bool = true
		Consts.SLOTS.ACTIVE:
			slot_bool = is_active()
		Consts.SLOTS.BENCH:
			slot_bool = not is_active()
		Consts.SLOTS.TARGET:
			slot_bool = Globals.fundies.get_targets().has(self)
		Consts.SLOTS.REST:
			slot_bool = not Globals.fundies.get_targets().has(self)
	
	return slot_bool and side_bool

func get_card_name() -> String:
	return current_card.name if is_filled() else "null"

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
	return current_card.name == evolution.pokemon_properties.evolves_from\
	 and not evolved_this_turn and evolution_ready

func can_devolve() -> bool:
	return evolved_from.size()

func has_condition(conditions: Array = ["Poison", "Burn",
 Consts.TURN_COND.PARALYSIS, Consts.TURN_COND.ASLEEP, Consts.TURN_COND.CONFUSION]):
	for cond in conditions:
		match cond:
			"Poison":
				if applied_condition.poison > 0:
					return true
			"Burn":
				if applied_condition.burn > 0:
					return true
			"Imprison":
				if applied_condition.imprision:
					return true
			"Shockwave":
				if applied_condition.shockwave:
					return true
			_:
				if applied_condition.turn_cond == cond:
					return true
	
	return false

func get_side() -> Consts.SIDES:
	if is_attacker():
		return Consts.SIDES.ATTACKING
	return Consts.SIDES.DEFENDING

func get_slot_pos() -> Consts.SLOTS:
	if is_active():
		return Consts.SLOTS.ACTIVE
	return Consts.SLOTS.BENCH

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

func has_occurance() -> bool:
	if get_pokedata().pokebody and get_pokedata().pokebody.occurance:
		return true
	if get_pokedata().pokepower and get_pokedata().pokepower.occurance:
		return true
	return false

#endregion
#--------------------------------------

#--------------------------------------
#region SLOTTING IN
func use_card(card: Base_Card, play_as: int) -> void:
	#Play fossils, basics and evolutions onto the bench
	if play_as & 1 != 0 or play_as & 256 != 0:
		set_card(card)
	elif play_as & 2 != 0:
		if current_card:
			evolve_card(card)
		else:
			set_card(card)
	elif play_as & 32 != 0:
		attatch_tool(card)
	elif play_as & 64 != 0:
		attatch_tm(card)
	#play energy onto any pokemon defined by placement
	elif play_as & 512 != 0:
		add_energy(card)
	else:
		printerr("You probably can't pay ", card, " on a pokeslot as ", play_as)

func set_card(card: Base_Card) -> void:
	current_card = card
	ui_slot.make_allowed(true)
	
	await ability_emit(played, get_slot_pos())
	refresh_current_card()

#General use function, use specific ones if possible
func remove_cards(cards: Array[Base_Card]) -> void:
	for card in cards:
		var removed: bool = false
		#Remove the tool card if it's here
		if tool_card and tool_card.same_card(card):
			remove_tool()
			continue
		#Remove the first energy card that matches this card
		for en in energy_cards:
			if en.same_card(card):
				remove_energy(en)
				removed = true
				break
		if removed: continue
		#Remove any evos if they're here
		for evo in evolved_from:
			if evo.same_card(card):
				devolve_card()
				removed = true

#endregion
#--------------------------------------

#--------------------------------------
#region DAMAGE HANDLERS
func should_ko() -> bool:
	return (get_pokedata().HP - damage_counters) < 0

func knock_out() -> void:
	await ability_emit(ko)

func add_damage(attacker: PokeSlot, base_ammount: int) -> void:
	var final_ammount = base_ammount
	
	if attacker.current_card.pokemon_properties.type & current_card.pokemon_properties.weak != 0:
		print(get_card_name(), " is weak to ", attacker.get_card_name())
		final_ammount *= 2
	if attacker.current_card.pokemon_properties.type & current_card.pokemon_properties.resist != 0:
		print(get_card_name(), " is resists to ", attacker.get_card_name())
		final_ammount -= 30
	
	final_ammount = clamp(final_ammount, 0, final_ammount)
	print(get_card_name(), " TAKES: ", final_ammount, " DAMAGE!")
	damage_counters += final_ammount
	@warning_ignore("integer_division")
	attacker.dealt_damage = final_ammount
	
	refresh()
	
	await ability_emit(take_dmg, attacker)

func bench_add_damage(_ammount) -> int:
	return 0

#Won't trigger anything that happens on direct damage
func dmg_manip(dmg_change: int, timer: int = -1) -> void:
	if timer == -1:
		damage_counters += clamp(dmg_change, 0, dmg_change)
	else:
		damage_timers.append({"Damage" : dmg_change, "Timer" : timer})
	refresh()

#endregion
#--------------------------------------

#--------------------------------------
#region ENERGY HANDLERS
func add_energy(energy_card: Base_Card):
	energy_cards.append(energy_card)
	energy_card.energy_properties.attatched_to = self
	
	register_energy_timer(energy_card)
	refresh()
	
	await ability_emit(attatch_en_signal, energy_card)

func remove_energy(removing: Base_Card):
	for card in energy_cards:
		if card.same_card(removing):
			energy_cards.erase(card)
			refresh()
			return
	
	await ability_emit(discard_en_signal, removing)
	printerr("Couldn't find ", removing.name, " in array ", energy_cards)

func register_energy_timer(card: Base_Card):
	if card.energy_properties.turns != -1:
		energy_timers[card] = card.energy_properties.turns

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
		if energy.energy_properties.attatched_to != self:
			energy.energy_properties.attatched_to = self
		var en_provide: EnData = energy.energy_properties.get_current_provide()
		var en_name: String = en_provide.get_string()
		attached_energy[en_name] += en_provide.number

func get_energy_strings() -> Array[String]:
	var energy_stirngs: Array[String]
	
	for card in energy_cards:
		var en_provide = card.energy_properties.get_current_provide()
		var en_name = en_provide.get_string()
		for i in range(en_provide.number):
			energy_stirngs.append(en_name)
	
	print_verbose("BEFORE SORT: ", energy_stirngs)
	
	energy_stirngs.sort_custom(func(a,b): #Basic + Darkness + Metal has highest priority
		return Consts.energy_types.find(a) < Consts.energy_types.find(b))
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
		var considered: String = card.energy_properties.considered
		if skip_category or card.energy_properties.considered == category_filter:
			final.append(card)
	return final

#Has a lot of work to do before ready
func get_energy_excess(enData_filter: EnData = null) -> int:
	print(current_attack.pay_cost(self))
	pass
	return get_total_energy(enData_filter) + current_attack.pay_cost(self)

#endregion
#--------------------------------------

#--------------------------------------
#region OTHER ATTATCHMENTS
func evolve_card(evolution: Base_Card) -> void:
	await ability_emit(evolving)
	disconnect_abilities()
	
	evolved_from.append(current_card)
	current_card = evolution
	refresh_current_card()
	setup_abilities()
	
	alleviate_all()
	await ability_emit(evolved, self)

func devolve_card() -> Base_Card:
	var old_card: Base_Card = current_card
	
	disconnect_abilities()
	current_card = evolved_from.pop_back()
	setup_abilities()
	refresh_current_card()
	
	return old_card

func attatch_tool(new_tool: Base_Card) -> void:
	if not tool_card:
		tool_card = new_tool
	else:
		push_error(current_card.name, " already has tool attatched")
	refresh()
	
	await ability_emit(attatched_tool, new_tool)

func remove_tool() -> void:
	tool_card = null
	refresh()

func attatch_tm(new_tm: Base_Card) -> void:
	tm_cards.push_front(new_tm)
	print("TMS: ",tm_cards)
	refresh()
	
	await ability_emit(attatched_tm, new_tm)

func remove_tms() -> void:
	tm_cards.clear()
	refresh()

#endregion
#--------------------------------------

#--------------------------------------
#region CONDITION HANDLERS
func add_condition(adding: Condition) -> void:
	applied_condition.poison = max(adding.poison, applied_condition.poison)
	applied_condition.burn = max(adding.burn, applied_condition.burn)
	
	if adding.turn_cond != Consts.TURN_COND.NONE:
		applied_condition.turn_cond = adding.turn_cond
	
	applied_condition.imprision = adding.imprision or applied_condition.imprision
	applied_condition.shockwave = adding.shockwave or applied_condition.shockwave
	
	refresh()
	
	await ability_emit(condition_applied, applied_condition)

func affected_by_condition() -> bool:
	var poisioned: bool = applied_condition.poison != 0
	var burnt: bool = applied_condition.burn != 0
	var turnt: bool = applied_condition.turn_cond != Consts.TURN_COND.NONE
	
	return poisioned or burnt or turnt

func alleviate_all() -> void:
	applied_condition.poison = 0
	applied_condition.burn = 0
	applied_condition.turn_cond = Consts.TURN_COND.NONE
	refresh()

func checkup_conditions():
	if applied_condition.poison != 0:
		prints("Poison", applied_condition.poison)
		damage_counters += applied_condition.poison * 10
		
	if applied_condition.burn != 0:
		prints("Burn", applied_condition.burn)
		damage_counters += applied_condition.burn * 10
		var result: bool = await condition_rule_utilize(Globals.board_state.burn_rules)
		if result:
			applied_condition.burn = 0
		
	if applied_condition.turn_cond == Consts.TURN_COND.PARALYSIS:
		print("Paralysis")
		applied_condition.turn_cond = Consts.TURN_COND.NONE
		var result: bool = await condition_rule_utilize(Consts.COND_RULES.TURN_PASS)
		if result:
			applied_condition.turn_cond = Consts.TURN_COND.NONE
		
	if applied_condition.turn_cond == Consts.TURN_COND.ASLEEP:
		print("Sleep")
		var result: bool = await condition_rule_utilize(Globals.board_state.sleep_rules)
		if result:
			applied_condition.turn_cond = Consts.TURN_COND.NONE

func condition_rule_utilize(using: Consts.COND_RULES):
	match using:
		Consts.COND_RULES.NONE:
			return false
		Consts.COND_RULES.FLIP:
			var result: int = Consts.coinflip_once.start_comparision()
			await SignalBus.finished_coinflip
			return result != 0
		Consts.COND_RULES.TWOFLIP:
			var result = Consts.coinflip_twice.start_comparision()
			await SignalBus.finished_coinflip
			print(result)
			return result
		Consts.COND_RULES.TURN_PASS:
			#Remove after thier side's turn ends
			print(get_card_name(), Globals.fundies.home_turn, is_home(), not is_attacker())
			return not is_attacker()

func confusion_check() -> bool:
	if applied_condition.turn_cond != Consts.TURN_COND.CONFUSION:
		return false
	
	var confused: bool = not await condition_rule_utilize(Globals.board_state.confusion_rules)
	
	if confused:
		dmg_manip(Globals.board_state.confusion_damage)
	
	return confused

#endregion
#--------------------------------------

#--------------------------------------
#region MANAGING DISPLAYS
func slot_into(destination: UI_Slot):
	ui_slot = destination
	refresh()

func refresh_current_card():
	ui_slot.name_section.clear()
	ui_slot.max_hp.clear()
	
	ui_slot.display_image(current_card)
	ui_slot.name_section.append_text(current_card.name)
	ui_slot.max_hp.append_text(str("HP: ",get_pokedata().HP))

func refresh() -> void:
	if not is_filled(): return
	#Change slot's card display
	ui_slot.name_section.clear()
	ui_slot.max_hp.clear()
	
	if current_card:
		ui_slot.display_image(current_card)
		ui_slot.name_section.append_text(current_card.name)
		ui_slot.max_hp.append_text(str("HP: ",get_pokedata().HP))
		ui_slot.damage_counter.set_damage(damage_counters)
		ui_slot.display_types(Convert.flags_to_type_array(get_pokedata().type))
		
		ui_slot.display_condition()
		
		#check for any attatched cards/conditions
		count_energy()
		ui_slot.display_energy(get_energy_strings(), attached_energy)
		
		if tm_cards.size():
			ui_slot.tm.texture = tm_cards[0].image
			ui_slot.tm.show()
		else: ui_slot.tm.hide()
		if tool_card:
			ui_slot.tool.show()
			ui_slot.tool.texture = tool_card.image
		else: ui_slot.tool.hide()
		
		refresh_connections()
		check_power_body()
		ui_slot.check_ability_activation()
		
	else:
		ui_slot.display_image(null)
		ui_slot.display_types([])
	
	#recognize position of slot
	ui_slot.connected_slot = self

#endregion
#--------------------------------------
