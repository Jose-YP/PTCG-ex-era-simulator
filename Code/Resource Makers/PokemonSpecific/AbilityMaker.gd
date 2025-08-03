extends Resource
class_name Ability

@export_enum("Body", "Power") var category: String = "Body"
@export var name: String = ""
@export_multiline var description: String = ""

##If they're affected by a condition they cannot use the ability as long as this is true
@export var affected_by_condition: bool = true
##Mon must be in active slot to use this ability
@export var active: bool = false
##How often can this ability be used in a per turn basis
@export_enum("Once per Mon", "Once per turn", "Infinite") var how_often: String = "Once per Mon"
##Any conditions to pass to activate the effect?
@export var prompt: PromptAsk
##If this ability activates at a certain time, when is that time? Uses signals from [member PokeSlot]
@export var occurance: Occurance
##This effects will activate without calling for any reactions from other slots
@export var passive: EffectCall
##This will call an ability activation
@export var effect: EffectCall

var attatched_to: PokeSlot

#region INITALIZATION
func prep_ability(slot: PokeSlot):
	attatched_to = slot
	if occurance:
		occurance = occurance.duplicate()
		occurance.connect_occurance()
		occurance.occur.connect(activate_ability)

func disconnect_ability():
	if occurance:
		occurance.disconnect_occurance()
		occurance.occur.disconnect(activate_ability)

func single_prep(slot: PokeSlot):
	if occurance:
		occurance.single_connect(slot)

func single_disconnect(slot: PokeSlot):
	if occurance:
		occurance.single_disconnect(slot)

#endregion

#region BOOLEANS
##Passives will activate on thier own
func does_press_activate(slot: PokeSlot) -> bool:
	if occurance:
		return false
	
	return general_allowed(slot)

func general_allowed(slot: PokeSlot) -> bool:
	var quick_result: bool = true
	if active:
		quick_result = slot.is_active()
	if affected_by_condition:
		quick_result = quick_result and not slot.has_condition()
	
	match how_often:
		"Once per Mon":
			var exhaust: bool = slot.body_exhaust if category == "Body" else slot.power_exhaust
			return not exhaust and check_allowed(slot) and quick_result
		"Once per Turn":
			return  not Globals.fundies.used_ability(name) and check_allowed(slot) and quick_result
		"Infinite":
			return check_allowed(slot) and quick_result
	
	return false

func check_allowed(slot: PokeSlot) -> bool:
	if prompt and prompt.has_check_prompt():
		Globals.fundies.record_single_src_trg(slot)
		var result: bool = prompt.check_prompt()
		Globals.fundies.remove_top_source_target()
		return result
	else:
		return true
#endregion

func activate_passive() -> bool:
	if prompt:
		if prompt.check_prompt():
			passive.play_effect()
			return true
	else:
		passive.play_effect()
		return true
	
	return false

func activate_ability():
	if not general_allowed(attatched_to):
		return
	if prompt:
		if prompt.has_check_prompt():
			var result: bool = prompt.check_prompt()
			if prompt.has_coinflip():
				await SignalBus.finished_coinflip
			if not result:
				SignalBus.ability_checked.emit()
				return
		
		if prompt.has_before_prompt():
			var went_back: bool = await prompt.before_activating()
			if went_back:
				SignalBus.ability_checked.emit()
				return
		if prompt.has_prompt_question():
			var confirmed: bool = await prompt.check_prompt_question()
			if not confirmed:
				SignalBus.ability_checked.emit()
				return
	
	await Globals.fundies.ui_actions.play_ability_activate(attatched_to, self)
	await effect.play_effect()
	
	match how_often:
		"Once per Mon":
			if category == "Body":
				attatched_to.body_exhaust = true
			else:
				attatched_to.power_exhaust = true
		"Once per Turn":
			Globals.fundies.used_ability(name)
	
	SignalBus.ability_checked.emit()
	SignalBus.ability_activated.emit()
