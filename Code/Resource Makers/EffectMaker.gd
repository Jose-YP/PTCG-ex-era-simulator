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
@export var instead_of_damage: bool = false
@export var do_nothing: bool = false
@export var retreat: bool = false
@export_enum("Can", "Flip", "Can't") var attack: int = 0

@export_group("Buff & Debuff")
@export_enum("PlayerAll", "OpponentAll", "Self",
"Defender", "Both Active", "Both Defending") var buff_target: int = 0 ##Who recieves the buff?
@export_range(-120, 120, 10) var attack_damage: int = 0 ##How much more damage to the active spot?
@export_range(-120, 120, 10) var defense: int = 0 ##How much less damage should be taken from opponent
@export var after_weak_res: bool = true ##Is it applied before or after weak/res

@export_group("Utility")
@export_enum("None", "P by P", "O by O",
 "O by P", "Both") var switch_type: int = 0
@export var search: Array[Search]

@export_group("Disruption")
@export_enum("Player", "Opponent") var disrupt_target: int = 0
@export_enum("None","Hand", "Deck") var disrupting: int = 0
@export var card_ammount: int = 0
@export_subgroup("Energy")
@export var energy_ammount: int = 0

@export_group("Other")
@export var healing: HealEffect
#mimicry might be it's own resource
@export_enum("No","AttatchedLimited", "Attatched",
 "AnyLimited", "Any") var mimic: int = 0
