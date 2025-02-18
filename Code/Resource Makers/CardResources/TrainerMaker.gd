extends Resource
class_name Trainer

@export_category("Properties")
@export_enum("Item", "Supporter",
"Tool", "Stadium", "TM",
"Rocket's Secret Machine") var considered: String = "Item"
@export_multiline var specific_requirement: String = ""
@export_multiline var description: String = ""

@export_group("Prerequisites")
@export var asks: Ask
@export var fail_effect: EffectCall
@export var success_effect: EffectCall
@export var always_effect: EffectCall

@export_group("Tool Properties")
##Is there anything that needs to happen for the tool to activate?
@export var activate_ask: Ask
##remove tool after it's effect is used
@export var remove_after: bool = true
##-1 means it lasts forever
@export var duration: int = -1

@export_group("TM Properties")
@export var provided_attack: Attack
