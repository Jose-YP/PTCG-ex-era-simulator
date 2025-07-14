@icon("res://Art/ProjectSpecific/drag-and-drop.png")
extends Node
class_name CardPlayer

signal chosen
#signal back

var play_functions: Array[Callable] = [play_basic_pokemon, play_evolution, 
play_place_stadium, play_attatch_tool, play_attatch_tm, play_fossil, 
play_energy, play_trainer]

var hold_candidate: PokeSlot

func _ready() -> void:
	SignalBus.connect_to(play_functions)
	SignalBus.get_candidate.connect(record_candidate)
	SignalBus.attack.connect(before_direct_attack)

func determine_play(card: Base_Card, placement: Placement = null) -> void:
	var card_type: int = Conversions.get_card_flags(card)
	#Play fossils, basics and evolutions onto the bench
	if card_type & 1 != 0 or (card_type & 2 != 0 and placement and not placement.evolve):
		play_basic_pokemon(card)
	elif card_type & 2 != 0 and placement and placement.evolve:
		play_evolution(card, placement)
	#play stadiums onto the stadium slot
	elif card_type & 32 != 0 :
		play_place_stadium(card)
	elif card_type & 256 != 0:
		play_fossil(card)
	#play energy onto any pokemon defined by placement
	elif card_type & 512 != 0:
		play_energy(card, placement)
	
	#play trainers
	else:
		play_trainer(card)

#--------------------------------------
#region MANAGING CARD PLAY
#For basic mons & fossils
#region ADD POKEMON
func play_basic_pokemon(card: Base_Card):
	#Insert the card onto an active spot if there is one
	for slot in Globals.full_ui.get_slots(Constants.SIDES.ATTACKING, Constants.SLOTS.BENCH):
		if not slot.connected_slot:
			Globals.fundies.hide_list()
			slot.set_card(card)
			slot.current_card = card
			slot.refresh()
			#Remove the card from hand
			Globals.fundies.stack_manager.play_card(card, Constants.STACKS.PLAY)
			return
	Conversions.get_allowed_flags("Basic")
	start_add_choice("Where will pokemon be benched", card, Conversions.get_allowed_flags("Basic"),
	 func(slot: PokeSlot): return not slot.is_filled(), true)
	await chosen
	
	#Otherwise tell sLot UI actions to prompt the user into placing the bench mon
	print("Active slots full")
	card.print_info()

func play_fossil(card: Base_Card):
	for slot in Globals.fundies.active_slots:
		if not slot.is_filled():
			Globals.fundies.hide_list()
			slot.set_card(card)
			slot.refresh()
			#Remove the card from hand
			Globals.fundies.stack_manager.play_card(card, Constants.STACKS.PLAY)
			return
	
	start_add_choice("Where will pokemon be benched", card, Conversions.get_allowed_flags("Fossil"),
	 func(slot: PokeSlot): return not slot.is_filled(), true)
	await chosen
	card.print_info()

#For evolutions on pokemon and fossils
func play_evolution(card: Base_Card, placement: Placement = null):
	var evo_fun: Callable = Globals.make_can_evo_from(card)
	
	if placement == null:
		start_add_choice(str("Evolve ", card.name, " from which Pokemon"), card,
		 Conversions.get_allowed_flags("Evolution"), evo_fun, true)
	else:
		var place_func = func placement_evo(slot):
			if slot.is_in_slot(Constants.SIDES.SOURCE,placement.slot):
				return evo_fun.call(slot)
			else: return false
		
		start_add_choice(str("Evolve ", card.name, " from which Pokemon"), card,
		 Conversions.get_allowed_flags("Evolution"), place_func, false)
	
	await chosen
	Globals.fundies.stack_manager.play_card(card, Constants.STACKS.PLAY)
	print("Attatch ", card.name)
	card.print_info()
#endregion
#For energy cards
func play_energy(card: Base_Card, placement:Placement = null):
	if placement == null:
		pass
	else:
		pass
	var energy_bool: Callable = func(slot: PokeSlot) -> bool:
		var result: bool = slot.is_filled() and slot.is_attacker()
		if card.energy_properties.asks:
			result = result and card.energy_properties.asks.check_ask(slot)
		printt(result, slot.get_card_name())
		return result
	
	
	start_add_choice(str("Attatch ", card.name, " to which Pokemon"), card, 
	 Conversions.get_allowed_flags("Energy"), energy_bool, true)
	
	await chosen
	Globals.fundies.stack_manager.play_card(card, Constants.STACKS.PLAY)
	print("Attatch ", card.name)
	card.print_info()

#region TRAINERS
func play_trainer(card: Base_Card):
	var trainer: Trainer = card.trainer_properties
	var allowed: bool = false
	Globals.fundies.record_source_target(Globals.fundies.home_turn, [], [])
	
	if trainer.prompt:
		print("This card has a prompt")
		if card.has_before_prompt():
			var went_back: bool = false
			went_back = await card.trainer_properties.prompt.before_activating() 
			if went_back:
				print("Nevermind")
				return
		
		if trainer.prompt.comparator:
			allowed = trainer.prompt.check_prompt()
			if trainer.prompt.has_coinflip():
				await SignalBus.finished_coinflip
				print("COINFLIP RESULT: ", allowed)
			else: print("Prompt Result: ", allowed)
		
		if trainer.prompt.formal_question:
			allowed = await trainer.prompt.check_prompt_question()
		
		print(str(card.name, " played it's ", "success effect" if allowed else "fail effect"))
	
	if card.is_considered("Supporter"):
		Globals.fundies.stack_manager.play_supporter(card, Globals.fundies.home_turn)
	
	if trainer.asks:
		print("This card has an ask")
	
	if not allowed and trainer.fail_effect:
		await trainer.fail_effect.play_effect()
	
	if allowed and trainer.success_effect:
		await trainer.success_effect.play_effect()
	else:
		print(trainer.success_effect)
	
	if trainer.always_effect:
		await trainer.always_effect.play_effect()
	
	if not card.is_considered("Supporter"):
		Globals.fundies.stack_manager.play_card(card, Constants.STACKS.DISCARD)
	Globals.fundies.remove_top_source_target()

#For tools
func play_attatch_tool(card: Base_Card):
	var tool_bool: Callable = func (slot: PokeSlot) -> bool:
		return slot.is_filled() and slot.is_attacker()\
		 and card.trainer_properties.asks.check_ask(slot)
	
	start_add_choice(str("Attatch ", card.name, " to which Pokemon"), card, 
	Conversions.get_allowed_flags("Tool"), tool_bool, true)
	
	await chosen
	Globals.fundies.stack_manager.play_card(card, Constants.STACKS.PLAY)
	print("Attatch ", card.name)
	card.print_info()

func play_attatch_tm(card: Base_Card):
	var tm_bool: Callable = func (slot: PokeSlot) -> bool:
		return slot.is_filled() and slot.is_attacker()\
		 and card.trainer_properties.asks.check_ask(slot)
	
	start_add_choice(str("Attatch ", card.name, " to which Pokemon"), card,
	Conversions.get_allowed_flags("TM"), tm_bool, true)
	
	await chosen
	Globals.fundies.stack_manager.play_card(card, Constants.STACKS.PLAY)
	print("Attatch ", card.name)
	card.print_info()

#For stadiums
func play_place_stadium(card: Base_Card):
	pass
#endregion

func manage_tutored(tutored_cards: Array[Base_Card], placement: Placement):
	for card in tutored_cards:
		determine_play(card, placement)

#endregion
#--------------------------------------

#--------------------------------------
#region CHOICE MANAGEMENT
func start_add_choice(instruction: String, card: Base_Card, play_as: int, bool_fun: Callable, reversable: bool):
	Globals.fundies.hide_list()
	Globals.fundies.ui_actions.set_adding_card(card)
	set_reversable(reversable)
	await generic_choice(instruction, bool_fun)
	
	if Globals.fundies.ui_actions.selected_slot:
		var went_back: bool = false
		if card.has_before_prompt() and not Conversions.playing_as_pokemon(play_as):
			Globals.fundies.record_single_src_trg(Globals.fundies.ui_actions.selected_slot)
			went_back = await card.play_before_prompt()
			Globals.fundies.remove_top_source_target()
		if not went_back:
			hold_candidate.use_card(card, play_as)
			hold_candidate = null
			print("Attatch ", card.name)
		else: print("I changed my mind")
	else:
		print("Nevermind")
	Globals.fundies.ui_actions.color_tween(Color.TRANSPARENT)

func get_choice_candidates(instruction: String, bool_fun: Callable, reversable: bool,
 choosing_player: Constants.PLAYER_TYPES = Constants.PLAYER_TYPES.PLAYER) -> PokeSlot:
	set_reversable(reversable)
	Globals.fundies.hide_list()
	hold_candidate = null
	await generic_choice(instruction, bool_fun)
	if hold_candidate:
		print("We'll choose ", hold_candidate.get_card_name())
		chosen.emit()
		return hold_candidate
	else:
		print("Nevermind")
		SignalBus.went_back.emit()
		return null

func generic_choice(instruction: String, bool_fun: Callable,\
 choosing_player: Constants.PLAYER_TYPES = Constants.PLAYER_TYPES.PLAYER):
	var ui_act: SlotUIActions = Globals.fundies.ui_actions
	ui_act.get_allowed_slots(bool_fun)
	
	var allow_slots: Array[UI_Slot] = ui_act.allowed_slots
	#If there's only one choice and there's no going back, make the choice instantly
	if allow_slots.size() == 1 and not ui_act.can_reverse:
		ui_act.choosing = true
		ui_act.left_button_actions(allow_slots[0].connected_slot)
	#Otherwise wait for player to choose
	else:
		ui_act.get_choice(instruction)
		await ui_act.chosen
	chosen.emit()

func record_candidate(slot: PokeSlot):
	hold_candidate = slot

func set_reversable(reversable: bool):
	Globals.fundies.ui_actions.can_reverse = reversable
#endregion
#--------------------------------------

#--------------------------------------
#region ATTACKING
func before_direct_attack(attacker: PokeSlot, with: Attack):
	print("Now before ", with.name, " from ", attacker.get_card_name())
	
	with.print_attack()
	
	if not with.both_active:
		get_choice_candidates("Who do you want to attack?", 
		func(slot: PokeSlot): return slot.is_in_slot(Constants.SIDES.DEFENDING, Constants.SLOTS.ACTIVE),
		true)
		
		if hold_candidate == null:
			return
		else:
			direct_attack(attacker, with, [hold_candidate])
	else:
		direct_attack(attacker, with, Globals.full_ui.get_poke_slots(Constants.SIDES.DEFENDING, Constants.SLOTS.ACTIVE))

#For attacks that use main dmg + effects
func direct_attack(attacker: PokeSlot, with: Attack, defenders: Array[PokeSlot]):
	print()
	pass

#For bench attacks
func bench_attack(attacker: PokeSlot, with: BenchAttk, defenders: Array[PokeSlot]):
	pass

#endregion
#--------------------------------------

#--------------------------------------
#region DETERMINING EFFECTS
func scope_effect():
	pass

#endregion
#--------------------------------------
