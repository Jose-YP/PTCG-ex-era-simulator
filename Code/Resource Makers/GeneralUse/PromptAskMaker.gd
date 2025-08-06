extends Resource
class_name PromptAsk

#region QUESTION
##Give a prompt asking to activate the effect?
@export var formal_question: bool = false
##This is the text given for context when a player must choose something
@export_multiline var question_string: String 
##This answer will return true for the prompt
@export var yes_answer: String
##This answer will return false for the prompt
@export var no_answer: String
#endregion

#@export var inherit_outside_comparator: bool = false
##What comparator must it pass to work? 
@export var comparator: Comparator
##For before activating prompts: 
##[member effect], [member choose_location], [member formal_ask]
##[br]Are they allowed cancel the prompt, forcing a failure?
@export var can_reverse: bool = true
##These must be performed before doing the proceeding effect/attack
@export var effect: EffectCall
##This is to be filled later, need to implement occurance resource and slot signals
@export var occurance: bool

#region CHOICE
@export_group("Choice")
##Who decides which to choose
@export var chooser: Consts.SIDES
##Does the user have to choose something before the effect can activate?
@export_enum("None", "Slot", "Stack") var choose_location: String = "None"
##This ask is for the user to first make a choice
@export var which_slots: SlotAsk
##From which stack should they make a choice
@export var which_stack: Consts.STACKS = Consts.STACKS.HAND
##Which cards are allowed in choice
@export var which_cards: Identifier
#endregion

var formal_answer: bool

#region PROMPT CHECKS
#Any prompts that can change in the moment
func check_prompt():
	var result: bool = false
	
	print("CHECKING COMPARATOR ", comparator.first_comparison)
	var found = comparator.start_comparision()
	print(found)
	result = result or found
	
	return result

func num_input_prompt():
	print("CHECKING COMPARATOR ", comparator.first_comparison)
	var found = await comparator.input_comparison()
	print(found)
	
	return found

func check_prompt_question():
	SignalBus.prompt_answered.connect(return_prompt_answered)
	
	var prompt_ask: ColorRect = Consts.prompt_answer.instantiate()
	prompt_ask.modulate = Color.TRANSPARENT
	Globals.full_ui.set_top_ui(prompt_ask)
	prompt_ask.load_answers(question_string, yes_answer, no_answer)
	
	await SignalBus.prompt_answered
	SignalBus.prompt_answered.disconnect(return_prompt_answered)
	return formal_answer

#Any prompts that are checked before playing card/effects
func before_activating() -> bool:
	var result: bool = false
	
	if effect:
		await effect.play_effect(can_reverse)
		print("DID WE GO BACK? ", effect.went_back)
		return effect.went_back
	if choose_location == "Slot":
		pass
	elif choose_location == "Stack":
		pass
	
	return result
#endregion

#region HELPER FUNCTIONS
func has_coinflip() -> bool:
	if comparator:
		return comparator.has_coinflip()
	return false

func has_num_input() -> bool:
	if comparator:
		return comparator.has_input()
	return false

func return_prompt_answered(result: bool):
	formal_answer = result

func has_check_prompt() -> bool:
	return comparator != null

func has_before_prompt() -> bool:
	return effect != null or choose_location != "None"

func has_prompt_question() -> bool:
	return formal_question
#endregion
