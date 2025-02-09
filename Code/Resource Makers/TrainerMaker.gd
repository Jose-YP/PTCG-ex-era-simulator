extends Resource
class_name Trainer

@export_category("Properties")
@export_enum("Item", "Supporter",
"Tool", "Stadium", "TM") var considered: String = "Item"
@export_multiline var description: String = ""

@export_category("Prerequisites")
@export var prerequisite: int = 0
@export var asks: Ask
@export var fail_effect: Effect
@export var success_effect: Effect
@export var always_effect: Effect
