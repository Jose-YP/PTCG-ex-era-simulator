extends Resource
class_name Trainer

@export_category("Properties")
@export_enum("Item", "Supporter",
"Tool", "Stadium", "TM",
"Rocket's Secret Machine") var considered: String = "Item"
@export_multiline var description: String = ""

@export_category("Prerequisites")
@export var asks: Ask
@export var fail_effect: EffectCall
@export var success_effect: EffectCall
@export var always_effect: EffectCall
