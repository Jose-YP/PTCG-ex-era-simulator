##Resource for cards that provide energy on top of any additional effects to attatching as energy
@icon("res://Art/Energy/48px-Colorless-attack.png")
extends Resource
class_name Energy

##Basic energy and special enegry each have thier own categories since different cards interact with each
##Darkness and Metal energy are considered special during the ex Series
@export_enum("Basic Energy", "Special Energy") var considered: String = "Special Energy"
##Any text that displays to explain how the card works
@export_multiline var description: String = ""

@export_group("Prerequisites")
##Is there anything the user must decide before attatching?[br]
##What should the game state be like for this card's [member success_effect] and [member type] to be used?
@export var prompt: PromptAsk
##Which slots are allowed to attatch this card?
@export var asks: SlotAsk
##Should failure constitute providing different kinds of energy?
@export var has_fail_provide: bool = false
##Failed asks mean the user can't attatch the energy
@export var has_fail_prevent: bool = false
@export_group("Effect")
##What should happen if the ask isn't met
@export var fail_effect: EffectCall 
##What should happen if the ask is met
@export var success_effect: EffectCall
##What should happen on attatch specifically
@export var attatch_effect: EffectCall 

@export_group("Provides")
##-1 means forever, otherwise it's how many turns it'll last 
##0 means it'll be removed after turn end
@export var turns: int = -1
##Providing multiple types means that one of the multiple types will be accounted for when counting energy
##[br]What types does this energy provide upon failure
@export var fail_provide: EnData
##What types does this energy provide upon success.
@export var success_provide: EnData

var attatched_to: PokeSlot

##Debug function to print out the specifics of the card's energy properties
func print_energy() -> void:
	var en_prov: EnData = get_current_provide()
	print("Class: ", considered ,"
	Types: ", Convert.flags_to_type_array(en_prov.type),"
	Number Provided: ", en_prov.number,"
	Description: ", description)
	
	print("-------------------------------------------------------------")

func get_current_provide() -> EnData:
	if (not prompt or not has_fail_provide)\
	 or fail_provide == success_provide or attatched_to == null:
		return success_provide
	
	Globals.fundies.record_single_src_trg(attatched_to)
	var result = prompt.check_prompt()
	Globals.fundies.remove_top_source_target()
	
	return success_provide if result else fail_provide

func get_current_type() -> int:
	return get_current_provide().type

func get_current_string() -> String:
	return get_current_provide().get_string()
