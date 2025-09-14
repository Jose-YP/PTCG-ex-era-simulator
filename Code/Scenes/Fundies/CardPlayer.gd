@icon("res://Art/ProjectSpecific/drag-and-drop.png")
extends Node
class_name CardPlayer

signal chosen

var retreat_discard: EnMov = load("res://Resources/Components/Effects/EnergyMovement/RetreatDis.tres")
var hold_candidate: PokeSlot
var hold_playing: Base_Card
var play_functions: Array[Callable] = [play_basic_pokemon, play_evolution, 
play_place_stadium, play_attatch_tool, play_attatch_tm, play_fossil, 
play_energy, play_trainer]

func _ready() -> void:
	SignalBus.connect_to(play_functions)
	SignalBus.get_candidate.connect(record_candidate)
	SignalBus.main_attack.connect(main_attack)
	SignalBus.trigger_attack.connect(trigger_attack)
	SignalBus.retreat.connect(retreating)

func determine_play(card: Base_Card, placement: Placement = null) -> void:
	var card_type: int = Convert.get_card_flags(card)
	#Play fossils, basics and evolutions onto the bench
	if card_type & 1 != 0 or (card_type & 2 != 0 and placement and not placement.evolve):
		await play_basic_pokemon(card, placement)
	elif card_type & 2 != 0 and placement and placement.evolve:
		await play_evolution(card, placement)
	#play stadiums onto the stadium slot
	elif card_type & 32 != 0 :
		await play_place_stadium(card)
	elif card_type & 256 != 0:
		await play_fossil(card)
	#play energy onto any pokemon defined by placement
	elif card_type & 512 != 0:
		await play_energy(card, placement)
	
	#play trainers
	else:
		await play_trainer(card)
	
	if placement and placement.mini_effect:
		Globals.fundies.print_src_trg()
		placement.mini_effect.play_effect()
		Globals.fundies.remove_top_source_target()

#--------------------------------------
#region MANAGING CARD PLAY
#For basic mons & fossils
#region ADD POKEMON
func play_basic_pokemon(card: Base_Card, placement: Placement = null):
	#Insert the card onto an active spot if there is one
	for slot in Globals.full_ui.get_slots(Consts.SIDES.ATTACKING, Consts.SLOTS.BENCH):
		if not slot.connected_slot:
			slot.set_card(card)
			slot.current_card = card
			slot.refresh()
			#Remove the card from hand
			Globals.fundies.stack_manager.play_card(card, Consts.STACKS.PLAY)
			return
	
	#Otherwise tell sLot UI actions to prompt the user into placing the bench mon
	#Convert.get_allowed_flags("Basic")
	print("Active slots full")
	
	await start_add_choice("Where will pokemon be benched", card, Convert.get_allowed_flags("Basic"),
	 func(slot: PokeSlot): return not slot.is_filled() and slot.is_attacker(), placement == null)
	
	if placement == null and hold_candidate != null:
		Globals.fundies.stack_manager.play_card(card, Consts.STACKS.PLAY)

func play_fossil(card: Base_Card):
	for slot in Globals.fundies.active_slots:
		if not slot.is_filled():
			slot.set_card(card)
			slot.refresh()
			#Remove the card from hand
			Globals.fundies.stack_manager.play_card(card, Consts.STACKS.PLAY)
			return
	
	await start_add_choice("Where will pokemon be benched", card, Convert.get_allowed_flags("Fossil"),
	 func(slot: PokeSlot): return not slot.is_filled(), true)
	
	card.print_info()

#For evolutions on pokemon and fossils
func play_evolution(card: Base_Card, placement: Placement = null):
	var evo_fun: Callable = Globals.make_can_evo_from(card)
	
	if placement == null:
		await start_add_choice(str("Evolve ", card.name, " from which Pokemon"), card,
		 Convert.get_allowed_flags("Evolution"), evo_fun, true)
	else:
		var place_func = func placement_evo(slot):
			if slot.is_in_slot(Consts.SIDES.SOURCE,placement.slot):
				return evo_fun.call(slot)
			else: return false
		
		await start_add_choice(str("Evolve ", card.name, " from which Pokemon"), card,
		 Convert.get_allowed_flags("Evolution"), place_func, false)
	
	Globals.fundies.stack_manager.play_card(card, Consts.STACKS.PLAY)
	print("Attatch ", card.name)
	card.print_info()
#endregion
#For energy cards
func play_energy(card: Base_Card, placement: Placement = null):
	var energy_bool: Callable
	
	if placement:
		energy_bool = func(slot: PokeSlot) -> bool:
			var result: bool = placement.slot_ask.check_ask(slot) and slot.is_attacker()
			if card.energy_properties.asks:
				result = result and card.energy_properties.asks.check_ask(slot)
			
			printt(result, slot.get_card_name())
			return result
	else:
		energy_bool = func(slot: PokeSlot) -> bool:
			var result: bool = slot.is_filled() and slot.is_attacker()
			if card.energy_properties.asks:
				result = result and card.energy_properties.asks.check_ask(slot)
			
			printt(result, slot.get_card_name())
			return result
	
	await start_add_choice(str("Attatch ", card.name, " to which Pokemon"), card, 
	 Convert.get_allowed_flags("Energy"), energy_bool, placement == null)
	
	#await chosen
	if hold_candidate == null:
		return
	
	Globals.fundies.stack_manager.play_card(card, Consts.STACKS.PLAY)
	
	print("Attatch ", card.name)
	card.print_info()
	
	if placement == null:
		Globals.fundies.attatched_energy = true

#region TRAINERS
func play_trainer(card: Base_Card):
	var trainer: Trainer = card.trainer_properties
	var first: EffectCollect = null
	var allowed: bool = false
	Globals.fundies.record_source_target(Globals.fundies.home_turn, [], [])
	hold_playing = card
	
	if trainer.prompt_effects[0].prompt:
		first = trainer.prompt_effects[0]
		var prompt: PromptAsk = trainer.prompt_effects[0].prompt
		if card.has_before_prompt():
			var went_back: bool = false
			went_back = await prompt.before_activating() 
			if went_back:
				print("Nevermind")
				return
		
		if prompt.comparator:
			allowed = prompt.check_prompt()
			if prompt.has_coinflip():
				await SignalBus.finished_coinflip
				print("COINFLIP RESULT: ", allowed)
			else: print("Prompt Result: ", allowed)
		
		if prompt.formal_question:
			allowed = await prompt.check_prompt_question()
		
		if not allowed and first.fail:
			await first.fail.play_effect()
		
		if allowed and first.success:
			await first.success.play_effect()
		
		print(str(card.name, " played it's ", "success effect" if allowed else "fail effect"))
	
	if card.is_considered("Supporter"):
		Globals.fundies.stack_manager.play_supporter(card, Globals.fundies.home_turn)
	
	for effect in trainer.prompt_effects:
		if effect == first:
			continue
		await effect.effect_collect_play()
	
	if not card.is_considered("Supporter"):
		Globals.fundies.stack_manager.play_card(card, Consts.STACKS.DISCARD)
	
	hold_playing = null
	Globals.fundies.remove_top_source_target()

func play_attatch_tool(card: Base_Card):
	var tool_bool: Callable = func (slot: PokeSlot) -> bool:
		return slot.is_filled() and slot.is_attacker()\
		 and card.trainer_properties.asks.check_ask(slot)
	
	await start_add_choice(str("Attatch ", card.name, " to which Pokemon"), card, 
	Convert.get_allowed_flags("Tool"), tool_bool, true)
	
	Globals.fundies.stack_manager.play_card(card, Consts.STACKS.PLAY)
	print("Attatch ", card.name)
	card.print_info()

func play_attatch_tm(card: Base_Card):
	var tm_bool: Callable = func (slot: PokeSlot) -> bool:
		return slot.is_filled() and slot.is_attacker()\
		 and card.trainer_properties.asks.check_ask(slot)
	
	await start_add_choice(str("Attatch ", card.name, " to which Pokemon"), card,
	Convert.get_allowed_flags("TM"), tm_bool, true)
	
	Globals.fundies.stack_manager.play_card(card, Consts.STACKS.PLAY)
	print("Attatch ", card.name)
	card.print_info()

func play_place_stadium(card: Base_Card):
	hold_playing = card
	
	hold_playing = null
#endregion

func manage_tutored(tutored_cards: Array[Base_Card], placement: Placement):
	for card in tutored_cards:
		await determine_play(card, placement)

#endregion
#--------------------------------------

#--------------------------------------
#region CHOICE MANAGEMENT
func start_add_choice(instruction: String, card: Base_Card, play_as: int,
 bool_fun: Callable, reversable: bool):
	Globals.fundies.ui_actions.set_adding_card(card)
	set_reversable(reversable)
	hold_playing = card
	hold_candidate = null
	await generic_choice(instruction, bool_fun)
	
	if Globals.fundies.ui_actions.selected_slot:
		var went_back: bool = false
		if card.has_before_prompt() and not Convert.playing_as_pokemon(play_as):
			Globals.fundies.record_single_src_trg(Globals.fundies.ui_actions.selected_slot)
			went_back = await card.play_before_prompt()
			Globals.fundies.remove_top_source_target()
		
		if not went_back:
			hold_candidate.use_card(card, play_as, reversable)
			print("Attatch ", card.name)
		
		else: print("I changed my mind")
	else:
		print("Nevermind")
	hold_playing = null

func get_choice_candidates(instruction: String, bool_fun: Callable, reversable: bool,
 choosing_player: Consts.PLAYER_TYPES = Consts.PLAYER_TYPES.PLAYER) -> PokeSlot:
	set_reversable(reversable)
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
 choosing_player: Consts.PLAYER_TYPES = Consts.PLAYER_TYPES.PLAYER):
	var ui_act: SlotUIActions = Globals.fundies.ui_actions
	ui_act.get_allowed_slots(bool_fun)
	
	var allow_slots: Array[UI_Slot] = ui_act.allowed_slots
	#If there's only one choice and there's no going back, make the choice instantly
	if allow_slots.size() == 0:
		return
	elif allow_slots.size() == 1 and not ui_act.can_reverse:
		ui_act.choosing = true
		ui_act.left_button_actions(allow_slots[0].connected_slot)
	#Otherwise wait for player to choose
	else:
		await ui_act.get_choice(instruction)
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
#Q. Let's say I have a Dark Pupitar out and I use "Explosive Evolution" and flip heads,
#so I get to search my deck for a Dark Tyranitar.
#However I also KO a Koffing that has the "Knockout Gas" Poké-BODY. Am I now Confused and Poisoned? Or does my evolution remove the special conditions before they effect me in any way?
#A. You do the damage from an attack first, if that triggers anything (in this case it does)
#you then do what is triggered, then you continue and do what the attack says besides damage.
#So the evolution portion of "Explosive Evolution" takes place AFTER Koffing's "Knockout Gas" goes off. (Sep 22, 2005 PUI Rules Team) 

#Shouldonly trigger when pressing an attack button from a pokemon card
func main_attack(attacker: PokeSlot, with: Attack):
	await before_direct_attack(attacker, with)
	await attacker.ability_emit(attacker.attacks, attacker)
	Globals.fundies.remove_top_source_target()
	
	SignalBus.end_turn.emit()

#Shold only trigger from triggered mimic attacks
func trigger_attack(attacker: PokeSlot, with: Attack):
	await before_direct_attack(attacker, with)
	Globals.fundies.remove_top_source_target()
	
	SignalBus.trigger_finished.emit()

func before_direct_attack(attacker: PokeSlot, with: Attack):
	var direct_bool: bool = with.needs_target()
	var attack_data: AttackData = with.attack_data
	var replace_num: int = -1
	
	print("Now before ", with.name, " from ", attacker.get_card_name())
	
	with.print_attack()
	
	if await attacker.confusion_check():
		return
	
	if attack_data.prompt:
		if attack_data.prompt.has_num_input():
			replace_num = await attack_data.prompt.num_input_prompt()
			attack_data.prompt_hold = replace_num
		if attack_data.prompt.has_before_prompt():
			Globals.fundies.record_single_src_trg(attacker)
			attack_data.prompt_hold = not await attack_data.prompt.before_activating()
			Globals.fundies.remove_top_source_target()
	attacker.current_attack = with
	
	if direct_bool:
		if not attack_data.both_active:
			await get_choice_candidates("Who do you want to attack?", 
			func(slot: PokeSlot): return slot.is_in_slot(Consts.SIDES.DEFENDING, Consts.SLOTS.ACTIVE)\
			and slot.is_filled(), true)
			
			if hold_candidate == null:
				return
			else:
				Globals.fundies.record_attack_src_trg(attacker.is_home(), [attacker], [hold_candidate])
				attack_data.prompt_hold = await check_prompt_reliant(attack_data.prompt)
				
				if attack_data.before_damage:
					await attack_effect(attacker, with.attack_data, replace_num)
				if attack_data.prompt_hold != false:
					await direct_attack(attacker, with, [hold_candidate])
		else:
			var def_active: Array[PokeSlot] = Globals.full_ui.get_poke_slots(Consts.SIDES.DEFENDING, Consts.SLOTS.ACTIVE)
			Globals.fundies.record_attack_src_trg(attacker.is_home(), [attacker], def_active)
			attack_data.prompt_hold = await check_prompt_reliant(attack_data.prompt)
			
			if attack_data.before_damage:
				await attack_effect(attacker, with.attack_data, replace_num)
			if attack_data.prompt_hold != false:
				await direct_attack(attacker, with, def_active)
	
	elif attack_data.bench_damage:
		print("This attack does bench damage")
		pass
	
	else: Globals.fundies.record_single_src_trg(attacker)
	
	if not attack_data.before_damage:
		Globals.fundies.atk_efect = true
		await attack_effect(attacker, with.attack_data, replace_num)
	
	Globals.fundies.atk_efect = false
	attacker.current_attack = null

#For attacks that use main dmg + effects
func direct_attack(attacker: PokeSlot, with: Attack, defenders: Array[PokeSlot]):
	print()
	var base_damage = await with.get_damage()
	
	for slot in defenders:
		await slot.add_damage(attacker, base_damage)
	
	if with.attack_data.self_damage > 0:
		await attacker.self_damage(with.attack_data.self_damage)

func bench_attack(attacker: PokeSlot, with: BenchAttk, defenders: Array[PokeSlot]):
	pass

func attack_effect(attacker: PokeSlot, with: AttackData, replace_num: int = -1):
	if with.prompt_effects:
		if with.prompt_hold != null:
			for effect in with.prompt_effects:
				await effect.shared_collect_play(with.prompt_hold)
		else:
			for effect in with.prompt_effects:
				await effect.effect_collect_play()

func check_prompt_reliant(prompt: PromptAsk):
	if prompt and prompt.has_check_prompt() and not prompt.has_num_input():
		var result = prompt.check_prompt()
		if prompt.has_coinflip():
			await SignalBus.finished_coinflip
		return result
	return null

func prompt_input(prompt: PromptAsk) -> int:
	var result
	if prompt.has_num_input():
		result = await prompt.num_input_prompt()
	return result

#endregion
#--------------------------------------

#--------------------------------------
#region RETREATING
func retreating(retreater: PokeSlot):
	retreat_discard.finished.connect(call_retreat_swap.bind(retreater))
	retreat_discard.energy_ammount = retreater.get_retreat()
	Globals.fundies.record_single_src_trg(retreater)
	
	print(retreat_discard.energy_ammount)
	if retreat_discard.energy_ammount == 0:
		call_retreat_swap(retreater)
	else:
		await retreat_discard.send_effect(true)
	
	retreat_discard.finished.disconnect(call_retreat_swap)

func call_retreat_swap(retreater: PokeSlot):
	await Consts.retreat_swap.switch(Consts.SIDES.ATTACKING, false)
	retreater.retreat.emit()
	Globals.fundies.remove_top_source_target()
#endregion
#--------------------------------------
##Apparently this is how multiple abilities  activate
##[url] https://compendium.pokegym.net/ruling/58/ [/url]
func decide_ability_order(connections: Array, param: Variant ,chooser: Consts.PLAYER_TYPES):
	var activating_slots: Array[PokeSlot]
	var occurances: Array[Callable]
	for connection in connections:
		#Only under this specific cicumpstance will it return the owner
		#I don't like doing this but I gotta do something
		activating_slots.append(connection["callable"].call("CheckingMultiples"))
		occurances.append(connection["callable"])
	
	while activating_slots.size() != 0:
		await get_choice_candidates("Choose which Power/Body to activate next",
		func(slot: PokeSlot): return slot in activating_slots,
		chooser)
		
		var index: int = activating_slots.find(hold_candidate)
		print(hold_candidate, index)
		if index == -1:
			printerr("Uh oh can't find ", hold_candidate.get_card_name(), " in activating_slots")
		occurances[index].call(param)
		await SignalBus.ability_activated
		
		activating_slots.erase(hold_candidate)
		occurances.erase(occurances[index])
		
		#Check if any slot has an already emited ability
		for slot in activating_slots:
			var should_remove: bool = false
			var mon: Pokemon = slot.get_pokedata()
			if mon.pokebody:
				should_remove = Globals.fundies.used_ability(mon.pokebody.name)
			if mon.pokepower:
				should_remove = should_remove or Globals.fundies.used_ability(mon.pokepower.name)
			
			if should_remove:
				occurances.remove_at(activating_slots.find(slot))
				activating_slots.erase(slot)
			#else:
				#print(Globals.fundies.used_turn_abilities, Globals.fundies.used_emit_abilities)
				#print(slot.get_card_name())
