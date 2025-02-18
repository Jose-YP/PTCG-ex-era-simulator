extends Resource
class_name EffectCall

enum effect_types{CONDITION, BUFF, DISRUPT, DISABLE, 
ENMOV, HEAL, DMGMANIP, SEARCH, SWAP, OTHER}

##Determine the order in which the effects are called
@export var order: Array[effect_types]
##Add a condition
@export var condition: Condition
##Buff/Debuff a pokemon's stats or properties
@export var buff: Buff
##Send cards elsewhere
@export var disruption: CardDisrupt
##Disable the player/pokemon's possible moves
@export var disable: Disable
##Move current energy in play
@export var energy_movement: EnMov
##Remove damage counters
@export var healing: HealEffect
##Move/Add damage counters around
@export var dmgManip: DamageManip
##Look for cards in deck/discard
@export var search: Array[Search]

@export_group("Minor Changes")
@export var remove_conditions: bool = false
@export var remove_shockwave: bool = false
@export var remove_imprison: bool = false
@export_enum("None", "P by P", "O by O",
 "O by P", "Both") var switch_type: int = 0
##mimicry might be it's own resource
@export_enum("No","AttatchedLimited", "Attatched",
 "AnyLimited", "Any") var mimic: int = 0

@export_group("Other")
##Ask for any extra effects
@export var ask_extra: Ask
##Do extra effect for extra ask
@export var extra_effect: EffectCall
