extends Resource
class_name PromptAsk

##Give a prompt asking to activate the effect?
@export var formal_ask: bool = false
##This is the text given for context when a player must choose something
##[br]When [member formal_ask] is [code]true[/code], seperate choices with ||
@export_multiline var ask_string: String 

##What comparator must it pass to work? 
@export var comparator: Comparator
##For before activating prompts: 
##[member effect], [member choose_location], [member formal_ask]
##[br]Are they allowed cancel the prompt, forcing a failure?
@export var can_reverse: bool = true
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

#Any prompts that can change in the moment
func check_prompt():
	var result: bool = false
	
	if comparator:
		print("CHECKING COMPARATOR ", comparator.first_comparison)
		var found = comparator.start_comparision()
		print(found)
		result = result or found
	
	elif formal_ask:
		pass
	
	return result

#Any prompts that are checked before playing card/effects
func before_activating() -> bool:
	if effect:
		await effect.play_effect(can_reverse)
		print("DID WE GO BACK? ", effect.went_back)
	if choose_location == "Slot":
		pass
	elif choose_location == "Stack":
		pass
	
	return effect.went_back

func has_before_prompt() -> bool:
	return effect != null or choose_location != "None" or formal_ask

func has_coinflip() -> bool:
	if comparator:
		var result: bool = comparator.first_comparison.has_coinflip()
		if comparator.second_counter:
			result = result or comparator.second_counter.has_coinflip()
		return result
	return false
