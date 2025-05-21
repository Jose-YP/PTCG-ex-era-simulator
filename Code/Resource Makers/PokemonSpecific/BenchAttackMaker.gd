extends Resource
class_name BenchAttk

@export_range(-1,5) var how_many: int = 1
##Which kinds of pokemon can the attacker pick
@export var candidates: SlotAsk
##This choice exists for simple choices that don't need asks
@export_enum("Player","Opponent","All") var which: int = 1
##The attacker can choose to attack an active pokemon instead
@export var active_allowed: bool = false

@export_group("Damage")
##Should you apply weak/res on bench mons
@export var apply_weak_res: bool = false
##Bench dmg/In case bench dmg is different from active dmg
@export_range(0,200,10) var initial_main_DMG: int = 0
##
@export_enum("None", "Add", "Multiply", "Subtract") var modifier: int = 0
@export var counter: Counter

@export_group("Effects")
@export var ask: SlotAsk
@export var effect: EffectCall
@export var fail_effect: EffectCall
