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
@export_enum("None","PlayerAll", "OpponentAll", "Self",
"Defender", "Both Active", "Both Defending") var disable_target: int = 0
@export var instead_of_damage: bool = false
@export var do_nothing: bool = false
@export_enum("Can", "Flip", "Can't") var attack: int = 0
@export_subgroup("Retrat")
##-1 means forever, otherwise it's turn duration
@export var retrat_duration: int = 1
@export var disable_retreat: bool = false


@export_group("Buff & Debuff")
##Who recieves the buff?
@export_enum("PlayerAll", "OpponentAll", "Self",
"Defender", "Both Active", "Both Defending") var buff_target: int = 0
##How much more damage to the active spot?
@export_range(-120, 120, 10) var attack_damage: int = 0
##How much less damage should be taken from opponent
@export_range(-120, 120, 10) var defense: int = 0
##Is it applied before or after weak/res
@export var after_weak_res: bool = true

@export_group("Utility")
@export_enum("None", "P by P", "O by O",
 "O by P", "Both") var switch_type: int = 0
@export var search: Array[Search]

@export_group("Disruption")
@export_enum("Player", "Opponent") var disrupt_target: int = 0
@export_enum("None","Hand", "Deck") var disrupting: int = 0
@export var card_ammount: int = 0
@export var reveal: bool = false
@export_subgroup("Energy")
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 0
@export var energy_ammount: int = 0

@export_group("Other")
@export var remove_conditions: bool = false
@export var remove_shockwave: bool = false
@export var remove_imprison: bool = false
@export var healing: HealEffect
##mimicry might be it's own resource
@export_enum("No","AttatchedLimited", "Attatched",
 "AnyLimited", "Any") var mimic: int = 0
##Ask for any extra effects
@export var ask_extra: Ask
##Do extra effect for extra ask
@export var extra_effect: EffectCall
