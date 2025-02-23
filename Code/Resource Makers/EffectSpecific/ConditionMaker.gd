extends Resource
class_name Condition

@export_group("Conditions")
##imprision/shockwave will ignore this
@export_enum("Attacker", "Actives", "Defender",
 "Both Defenders") var which: int = 2

@export var choose_condition: bool = false
@export_enum("None", "Normal", "Heavy") var poison: int = 0
@export_enum("None", "Normal", "Heavy") var burn: int = 0
@export_flags("Imprision", "Shockwave") var addable_effects: int = 0
@export_enum("None","Asleep",
"Paralyze", "Confused") var mutually_exclusive_conditions: int = 0
@export var knockOut: bool = false
