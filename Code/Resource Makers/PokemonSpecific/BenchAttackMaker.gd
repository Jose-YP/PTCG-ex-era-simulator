extends Resource
class_name BenchAttk

##How many benched pokemon should take this damage, if it's -1 ignore and hurt everyone
@export_range(-1,5) var how_many: int = 1
##Which kinds of pokemon can the attacker pick
@export var candidates: SlotAsk
##This choice exists for simple choices that don't need asks
@export var which: Constants.SIDES = Constants.SIDES.DEFENDING
##The attacker can choose to attack an active pokemon instead
@export var active_allowed: bool = false

@export_group("Damage")
##Should you apply weak/res on bench mons
@export var apply_weak_res: bool = false
##Bench dmg/In case bench dmg is different from active dmg
@export_range(0,200,10) var initial_main_DMG: int = 10
##None - Use [member initial_main_DMG] as is
##[br]Add - use [member initial_main_DMG] then add damage depending on [member counter] and [member prompt]
##[br]Multiply - use [member initial_main_DMG] times the result found with [member counter] and [member prompt], allows 0 as a result
##[br]Subtract - use [member initial_main_DMG] then add damage depending on [member counter] and [member prompt]
@export_enum("None", "Add", "Multiply", "Subtract") var modifier: int = 0
@export var comparator: Comparator

@export_group("Effects")
@export var prompt: PromptAsk
@export var ask: SlotAsk
@export var effect: EffectCall
@export var success_effect: EffectCall
@export var fail_effect: EffectCall
