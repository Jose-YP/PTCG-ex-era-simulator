extends Resource
class_name BenchAttk

@export_range(-1,5) var how_many: int = 1
@export var candidates: Ask
@export_enum("Player","Opponent","All") var which: int = 1

@export_group("Damage")
@export var apply_weak_res: bool = false
@export_range(0,200,10) var initial_main_DMG: int = 0
@export_enum("None", "Add", "Multiply", "Subtract") var modifier: int = 0
@export var counter: Counter

@export_group("Effects")
@export var ask: Ask
@export var effect: EffectCall
@export var fail_effect: EffectCall
