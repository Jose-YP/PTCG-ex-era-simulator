extends Resource
class_name AttackData

@export_group("Ignore")
##Don't check any of these if they're checked
@export_flags("Body", "Weakness", "Resistance", "Effects") var defender_properties: int = 0
##The pokemon can use this attack even if it has these conditions
@export_flags("None", "Paralysis", "Alseep", "Confusion") var condition: int = 1

@export_group("Damage")
##If this is true, then the [member prompt] must be true before dealing any dmg 
@export var prompt_reliant: bool = false
##Dmg that displays on the main card info next to name
@export_range(0,200,10) var initial_main_DMG: int = 0
@export_subgroup("Self Damage")
##If this is true then dmg can be increased/activated depending on [member prompt] and [member ask]
##[br]Otherwise the pokemon will take this dmg after attacking
@export var conditional_self_dmg: bool = false
@export_range(0,200,10) var self_damage: int = 0
@export_subgroup("Modifier")
##[member comparator] * [member prompt] will be multiplied by [member modifier_num] then...
##[br][enum None] - Use [member initial_main_DMG] as is or modified damage if prompt fails
##[br][enum Add] - use [member initial_main_DMG] then add damage depending from modified damage
##[br][enum Multiply] - use modified damage as the result
##[br][enum Subtract] - use [member initial_main_DMG] then subtract damage depending from modified damage
@export_enum("None", "Add", "Multiply", "Subtract") var modifier: int = 0
##When the comparator returns, how much will it be multiplied by?
@export_range(0,200,10) var modifier_num: int = 0
##Determines how damage should be changed
##[br][i]If modifieer is none, this can replace [member initial_main_DMG]
@export var comparator: Comparator
@export_subgroup("Alt Targetting")
##Does this attack hit both defending pokemon in doubles?
@export var both_active: bool = false
@export var bench_damage: BenchAttk

@export_group("Effects")
@export var prompt: PromptAsk
@export var ask: SlotAsk
##If [member prompt] and [member ask] are true then this effect will occur
@export var success_effect: EffectCall
##If [member prompt] and [member ask] are false then this effect will occur
@export var fail_effect: EffectCall
##This effect will always occur no matter [member prompt] and [member ask]
@export var always_effect: EffectCall
