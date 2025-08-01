extends Resource
class_name Ability

@export_enum("Body", "Power") var category: String = "Body"
@export var name: String = ""
@export_multiline var description: String = ""

@export var affected_by_condition: bool = true
@export var active: bool = false
@export_enum("Once per Mon", "Once per turn", "Infinite") var how_often: String = "Once per Mon"
@export var prompt: PromptAsk
@export var occurance: Occurance
@export var passive: EffectCall
@export var effect: EffectCall

var allowed: bool

#region INITALIZATION
func prep_ability():
	if occurance:
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

##Passives will activate on thier own
func does_press_activate(slot: PokeSlot) -> bool:
	if occurance:
		return false
	
	var quick_result: bool = true
	if active:
		quick_result = slot.is_active()
	if affected_by_condition:
		quick_result = quick_result and not slot.has_condition()
	
	match how_often:
		"Once per Mon":
			return not slot.power_exhaust and check_allowed(slot) and quick_result
		"Once per Turn":
			return  not Globals.fundies.used_ability(name) and check_allowed(slot) and quick_result
		"Infinite":
			return check_allowed(slot) and quick_result
	
	return false

func check_allowed(slot: PokeSlot) -> bool:
	if prompt:
		Globals.fundies.record_single_src_trg(slot)
		var result: bool = prompt.check_prompt()
		Globals.fundies.remove_top_source_target()
		return result
	else:
		return true

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
	if prompt and prompt.has_before_prompt():
		var went_back: bool = await prompt.before_activating()
		if went_back: return
	
	await effect.play_effect()
	SignalBus.ability_activated.emit()
