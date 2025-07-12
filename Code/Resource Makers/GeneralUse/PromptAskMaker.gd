extends Resource
class_name PromptAsk

##Give a prompt asking to activate the effect?
@export var formal_ask: bool = false
##This is the text given for context when a player must choose something
##[br]When [member formal_ask] is [code]true[/code], seperate choices with ||
@export_multiline var ask_string: String 

##What comparator must it pass to work? 
@export var comparator: Comparator
##These must be performed before doing the proceeding effect/attack
@export var effect: EffectCall

@export_group("Choice")
##Who decides which to choose
@export var chooser: Constants.SIDES
##Does the user have to choose something before the effect can activate?
@export_enum("None", "Slot", "Stack") var choose_location: String = "None"
##This ask is for the user to first make a choice
@export var which_slots: SlotAsk
##From which stack should they make a choice
@export var which_stack: Constants.STACKS = Constants.STACKS.HAND
##Which cards are allowed in choice
@export var which_cards: Identifier

signal finished

var result: bool = false

#Await for any coin flips in card player
func check_prompt():
	result = false
	
	if comparator:
		print("CHECKING COMPARATOR")
		var found = comparator.start_comparision()
		print(found)
		result = result or found
		
	if choose_location == "Slot":
		pass
	elif choose_location == "Stack":
		pass
	elif formal_ask:
		pass
	if effect:
		pass
	
	
	return result

func get_result():
	return result
