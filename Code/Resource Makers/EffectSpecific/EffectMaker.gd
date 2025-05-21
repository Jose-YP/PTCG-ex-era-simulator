extends Resource
class_name EffectCall


enum effect_types{CONDITION, BUFF, DISRUPT, DISABLE, 
ENMOV, DMGMANIP, SEARCH, SWAP, DRAW, OTHER}

##Determine the order in which the effects are called.
##It's best to fill this in, if you don't want the default enum order
@export var order: Array[effect_types]
##Add a condition
@export var condition: Condition
##Draw an ammount of cards
@export var draw_ammount: Counter
##Buff/Debuff a pokemon's stats or properties
@export var buff: Buff
##Send cards elsewhere
@export var card_disrupt: CardDisrupt
##Disable the player/pokemon's possible moves
@export var disable: Disable
##Move current energy in play
@export var energy_movement: EnMov
##Move/Add damage counters around
@export var dmgManip: DamageManip
##Look for cards in deck/discard
@export var search: Array[Search]

@export_group("Minor Changes")
@export_subgroup("Status Heal")
@export var remove_conditions: bool = false
@export var remove_shockwave: bool = false
@export var remove_imprison: bool = false
@export_subgroup("Switch")
##Does the target choose which active mon to switch out?
##If not it's the defender
@export var choose_active: bool = false
##Who switches according to who
@export_enum("None", "P by P", "O by O",
 "O by P", "Both") var switch_type: int = 0
@export_subgroup("Mimic")
##mimicry might be it's own resource
@export_enum("No","AttatchedLimited", "Attatched",
 "AnyLimited", "Any") var mimic: int = 0

@export_group("Other")
##SlotAsk for any extra effects
@export var ask_extra: SlotAsk
##Do extra effect for extra ask
@export var extra_effect: EffectCall
