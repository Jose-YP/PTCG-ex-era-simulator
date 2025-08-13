@icon("res://Art/ProjectSpecific/man.png")
extends Resource
class_name Mimic

##Which slot will recieve all of these attacks
@export var mimicing: SlotAsk
@export_enum("Slot", "Stack") var use: String = "Slot"
##Target for mimicry
@export var ask: SlotAsk
@export var mimic_self: bool = false
##Make this true for mimic attacks to function, false for passives[br]
##If true then the user will be able to attack again with the gathered attacks[br]
##If false the attacks will be stored in the user to be used later
@export var retrigger: bool = true
##Take attacks from stated pokemon + any cards they evolved from
@export var evolutions: bool = false
##You can only use the attack if you meet the energy requirements
@export var must_pay_energy: bool = false
@export var adjustable_type: bool = false
@export_group("Stack Exclusive")
@export var stack: Consts.STACKS
@export var identifier: Identifier

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
	if use == "Stack":
		pass
	
	var attacks: Array[Attack] = []
	var slots: Array[PokeSlot] = Globals.full_ui.get_ask_slots(ask)
	var mimiced_from: Array[String]

	for slot in slots:
		if (slot == target and not mimic_self) or slot.current_card.get_formal_name() in mimiced_from:
			continue
		attacks.append_array(slot.get_pokedata().attacks)
		mimiced_from.append(slot.current_card.get_formal_name())
		
		#erase any attacks that mimic if retrigger
	
	target.mimic_attacks = attacks
	
	if retrigger:
		var mimic_box: MimicBox = Consts.mimic_box.instantiate()
		mimic_box.attacks = target.mimic_attacks
		mimic_box.pay_costs = must_pay_energy
		Globals.full_ui.set_top_ui(mimic_box)
		await SignalBus.attack
		Globals.full_ui.remove_top_ui()
		pass
