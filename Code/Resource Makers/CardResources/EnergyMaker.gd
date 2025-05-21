##Resource for cards that provide energy on top of any additional effects to attatching as energy

extends Resource
class_name Energy

#@export_group("Properties")
##Basic energy and special enegry each have thier own categories since different cards interact with each
##Darkness and Metal energy are considered special during the ex Series
@export_enum("Basic Energy", "Special Energy") var considered: String = "Special Energy"
##Any text that displays to explain how the card works
@export_multiline var description: String = ""

@export_group("Prerequisites")
##What should the game state be like for this card to be used?
@export var asks: SlotAsk
##Should failure constitute providing different kinds of energy?
@export var fail_provide: bool = false
##Failed asks mean the user can't attatch the energy
@export var fail_prevent: bool = false
@export_group("Effect")
##What should happen if the ask isn't met
@export var fail_effect: EffectCall 
##What should happen if the ask is met
@export var success_effect: EffectCall
##What should happen on attatch specifically
@export var attatch_effect: EffectCall 

@export_group("Duration")
##-1 means forever, otherwise it's how many turns it'll last 
##0 means it'll be removed after turn end
@export var turns: int = -1

@export_group("Provides")
##How much energy does this provide on a succesful attatch
@export var number: int = 1
##React energy interacts with several poke-powers, so it needs to be categorized
##It doesn't provide different types however, so it's not considered as one
@export var react: bool = false
##Holon's energy are thier own categoory so they can be interacted with
@export_enum("None","FF","GL","WP") var holon_type: String = "None"
##What types does this energy provide upon success.
##
##Providing multiple types means that one of the multiple types will be accounted for when counting energy
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 1
##What types does this energy provide upon failure
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var fail_type: int = 1

##Debug function to print out the specifics of the card's energy properties
func print_energy() -> void:
	print("Class: ", considered ,"
	Types: ", Conversions.flags_to_type_array(type),"
	Number Provided: ", number,"
	Description: ", description)
	
	print("-------------------------------------------------------------")

##Funciton that tells the game how the energy should be displayed visually
##Not every combination of type needs to be accounted for
## only the ones that appear in the ex Series
##[br]
##* Basic Types
##[br]
##* Rainbow
##[br]
##* Holon's
##[br]
##* React
##[br]
##* Magma & Aqua
##[br]
##* DarkMetal
func how_display(passed: bool = true) -> String:
	#Figure out how the energy will be displayed
	var using: int = 0
	if passed: using = type
	else: passed = fail_type
	
	if react: return "React"
	if holon_type != "None": return holon_type
	if using == 2 ** 9 - 1: return "Rainbow"
	elif using == 2 ** 7 + 2 ** 6: return "Dark Metal"
	elif using == 2 ** 5 + 2 ** 6: return "Magma"
	elif using == 2 ** 2 + 2 ** 6: return  "Aqua"
	
	var index = int((log(float(using)) / log(2)))
	return Constants.energy_types[index]
