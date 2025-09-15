extends Resource
class_name Trainer

@export_category("Properties")
@export_enum("Item", "Supporter",
"Tool", "Stadium", "TM",
"Rocket's Secret Machine") var considered: String = "Item"
@export_multiline var specific_requirement: String = ""
@export_multiline var description: String = ""

@export_category("Effect")
##What should be asked for this to even happen
@export var prompt: PromptAsk
##Does anyone need to be a certain way to activate this
@export var asks: SlotAsk
@export var prompt_effects: Array[EffectCollect]
@export var stadium_properties: Stadium
@export var tool_properties: ToolCard
@export var provided_attack: Attack

#If I don't make godot look at these effects from the trainer, it won't be seen ever
func has_effect(effect_type: Array[String]):
	if prompt and prompt.effect:
		if prompt.effect.has_effect_type(effect_type):
			return true
	if provided_attack:
		if provided_attack.has_effect(effect_type):
			return true
	if tool_properties:
		pass
	if stadium_properties:
		pass
	return false

func print_trainer() -> void:
	print("Class: ", considered,"
	Description: ", description)
	print("-------------------------------------------------------------")
