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
@export var fail_effect: EffectCall
@export var success_effect: EffectCall
@export var always_effect: EffectCall
@export var stadium_properties: Stadium
@export var tool_properties: ToolCard
@export var provided_attack: Attack

#If I don't make godot look at these effects from the trainer, it won't be seen ever
func _init() -> void:
	if fail_effect:
		if fail_effect.swap: pass
		if fail_effect.alleviate: pass
		if fail_effect.mimic: pass
	if success_effect:
		if success_effect.swap: pass
		if success_effect.alleviate: pass
		if success_effect.mimic: pass
	if always_effect:
		if always_effect.alleviate: pass
		if always_effect.mimic: pass

func play_card():
	if fail_effect:
		fail_effect.play_effect()
	if success_effect:
		success_effect.play_effect()
	if always_effect:
		always_effect.play_effect()

func has_effect(effect_type: Array[String]):
	if success_effect:
		if success_effect.has_effect_type(effect_type):
			return true
	if fail_effect:
		if fail_effect.has_effect_type(effect_type):
			return true
	if always_effect:
		if always_effect.has_effect_type(effect_type):
			return true
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
