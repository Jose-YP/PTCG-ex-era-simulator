extends Resource
class_name Ability

@export_enum("Body", "Power") var category: String = "Body"
@export var name: String = ""
@export_multiline var description: String = ""

@export var affected_by_condition: bool = true
@export var active: bool = false
@export_enum("Passive", "Once per Mon", "Once per turn", "Infinite") var how_often: int = 0
@export var on_occurance: bool = false
@export var prompt: PromptAsk
@export var occurance: Occurance
@export var passive: EffectCall
@export var effect: EffectCall

func prep_ability():
	if occurance.connect_occurance():
		occurance.occur.connect(activate_ability)

func disconnect_ability():
	if occurance.connect_occurance():
		occurance.occur.disconnect(activate_ability)

##Passives will activate on thier own
func does_press_activate(slot: PokeSlot):
	if occurance:
		return false
	
	match how_often:
		"Passive":
			return false
		"Once Per Mon":
			return not slot.power_exhaust and check_allowed(slot)
		"Once Per Turn":
			return not Globals.fundies.used_ability(name) and check_allowed(slot)
		"Infinite":
			return check_allowed(slot)

func check_allowed(slot: PokeSlot) -> bool:
	if prompt:
		Globals.fundies.record_single_src_trg(slot)
		var result: bool = prompt.check_prompt()
		Globals.fundies.remove_top_source_target()
		return result
	else:
		return true

func activate_ability():
	if prompt.has_before_prompt():
		var went_back: bool = await prompt.before_activating()
		if went_back: return
	
	effect.play_effect()
