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

func play_card():pass

func print_trainer() -> void:
	print("Class: ", considered,"
	Description: ", description)
	print("-------------------------------------------------------------")
