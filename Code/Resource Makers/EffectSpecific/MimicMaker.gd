@icon("res://Art/ProjectSpecific/man.png")
extends Resource
class_name Mimic

##Which slot will recieve all of these attacks
@export var mimicing: SlotAsk
@export_enum("Slot", "Stack") var use: String = "Slot"
##Target for mimicry
@export var ask: SlotAsk
##Make this true for mimic attacks to function, false for passives[br]
##If true then the user will be able to attack again with the gathered attacks[br]
##If false the attacks will be stored in the user to be used later
@export var retrigger: bool = true
##Take attacks from stated pokemon + any cards they evolved from
@export var evolutions: bool = false
##You can only use the attack if you meet the energy requirements
@export var must_pay_energy: bool = false
@export var adjustable_type: bool = false
@export_group("Miscellaneous")
@export var mimic_self: bool = false
@export var hard_reverse: bool = false
@export var exclusive_mimic: Array[String]
@export_group("Stack Exclusive")
@export var stack: Consts.STACKS
@export var identifier: Identifier

const is_pokemon: Identifier = preload("res://Resources/Components/Effects/Identifiers/Pokemon/AnyPokemon.tres")

signal finished

#https://compendium.pokegym.net/compendium-ex.html
#Q. If Meteor Falls is in play, can Mew-EX use its "Versatile" Poké-BODY to copy any
#pre-evolution attack? Or can it copy attacks from attached Technical Machine trainers?
#A. No. Mew-EX can only copy attacks from the Pokémon that are in play.
#It cannot copy attacks granted by other cards, such as Technical Machines or Stadium cards.
#Q. Can I use "Disable" or "Amnesia" against my opponent's active Mew-EX to prevent
#"Versatile" from using the attack of another Pokémon in play?
#A. No. Versatile only let's Mew-EX *use* the attack of another Pokémon in play.
#Versatile does not copy the attacks onto Mew-EX, so they cannot be targeted by Disable or Amnesia

func play_effect(reversable: bool = false, replace_num: int = -1) -> void:
	print("PLAY MIMIC")
	
	var mimic_to: Array[PokeSlot] = Globals.full_ui.get_ask_slots(mimicing)
	
	for slot in mimic_to:
		await mimic(slot)
	
	finished.emit()

func mimic(target: PokeSlot):
	#Dictionary to prevent repeats
	var attacks: Dictionary[Attack,Attack]
	var slots: Array[PokeSlot] = Globals.full_ui.get_ask_slots(ask)
	var mimiced_from: Array[String]
	
	if use == "Slot":
		for slot in slots:
			if slot.current_card.get_formal_name() in mimiced_from:
				continue
			var loc_attacks: Array[Attack] = get_mimic_attacks(target, slot)
			for atk in loc_attacks:
				attacks[atk] = atk
			mimiced_from.append(slot.current_card.get_formal_name())
		#erase any attacks that mimic if retrigger
		if retrigger:
			if attacks.size() == 0:
				return
			elif attacks.size() == 1:
				var attack: Attack = attacks.keys().pop_front()
				if must_pay_energy and attack.can_pay(target) or not must_pay_energy:
					SignalBus.trigger_attack.emit(target, attack)
				else:
					pass
			else:
				var mimic_box: MimicBox = Consts.mimic_box.instantiate()
				mimic_box.attacks = attacks.keys() as Array[Attack]
				mimic_box.pay_costs = must_pay_energy
				mimic_box.poke_slot = target
				mimic_box.position = Vector2(target.ui_slot.global_position.x,0)
				Globals.full_ui.set_top_ui(mimic_box)
		else:
			target.mimic_attacks = attacks.keys() as Array[Attack]
	else:
		var stacks: CardStacks = Globals.fundies.stack_manager.get_stacks(ask.side_target)
		var mimic_card_list: MimicCardList = Consts.mimic_card_box.instantiate()
		mimic_card_list.list = stacks.identifier_search(stack, is_pokemon)
		mimic_card_list.target = target
		mimic_card_list.must_pay_energy = must_pay_energy
		Globals.full_ui.set_top_ui(mimic_card_list)
		
		await mimic_card_list.finished
	await SignalBus.trigger_finished
	

func get_mimic_attacks(target: PokeSlot, slot: PokeSlot) -> Array[Attack]:
	var mimic_attacks: Array[Attack] = []
	if evolutions:
		mimic_attacks.append_array(slot.get_evo_attacks())
	if (slot == target and not mimic_self):
		return mimic_attacks
	for atk in slot.get_pokedata().attacks:
		if exclusive_mimic.size() != 0:
			if atk.name in exclusive_mimic:
				mimic_attacks.append(atk)
		else:
			mimic_attacks.append(atk)
	
	return mimic_attacks
