extends Resource
class_name Condition

@export_group("Conditions")
##imprision/shockwave will ignore this
@export var side: Constants.SIDES = Constants.SIDES.OPP
@export var slot: Constants.SLOTS = Constants.SLOTS.DEFENDER

@export var choose_condition: bool = false
@export_enum("None", "Normal", "Heavy") var poison: int = 0
@export_enum("None", "Normal", "Heavy") var burn: int = 0
@export_flags("Imprision", "Shockwave") var addable_effects: int = 0
@export_enum("None","Asleep",
"Paralyze", "Confused") var mutually_exclusive_conditions: int = 0
@export var knockOut: bool = false

func play_effect(fundies: Fundies):
	print("PLAYING CONDITION")
