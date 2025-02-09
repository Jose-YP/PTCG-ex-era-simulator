extends Resource
class_name EffectCall

@export_group("Conditions")
@export_enum("None", "Normal", "Heavy") var poison: int = 0
@export_enum("None", "Normal", "Heavy") var burn: int = 0
@export_flags("Imprision", "Shockwave") var addable_effects: int = 0
@export_enum("None","Asleep",
"Paralyze", "Confused") var mutually_exclusive_conditions: int = 0
@export var knockOut: bool = false

@export_group("Disable")
@export var do_nothing: bool = false
@export var retreat: bool = false
@export_enum("Can", "Flip", "Can't") var attack: int = 0

@export_group("Buff/Debuff")
@export_enum("Player", "Opponent") var buff_target: int = 0

@export_group("Utility")
@export var search: Array[Search]

@export_group("Disruption")
@export_enum("Player", "Opponent") var disrupt_target: int = 0
@export_enum("None","Hand", "Deck") var disrupting: int = 0
@export var card_ammount: int = 0
@export_subgroup("Energy")
@export var energy_ammount: int = 0


@export_group("Other")
#mimicry might be it's own resource
@export_enum("No", "Pay Cost", "Any") var mimic: int = 0
