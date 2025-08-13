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
@export_group("Stack Exclusive")
@export var stack: Consts.STACKS
@export var identifier: Identifier

signal finished

func play_effect(reversable: bool = false, replace_num: int = -1) -> void:
	print("PLAY MIMIC")
	
	var mimic_to: Array[PokeSlot] = Globals.full_ui.get_ask_slots(mimicing)
	
	for slot in mimic_to:
		mimic(slot)
	
	finished.emit()

func mimic(target: PokeSlot):
	if use == "Stack":
		pass
	
	var attacks: Array[Attack] = []
	var slots: Array[PokeSlot] = Globals.full_ui.get_ask_slots(ask)
	
	for slot in slots:
		attacks.append_array(slot.get_pokedata().attacks)
		
		#erase any attacks that mimic if retrigger
	
	
