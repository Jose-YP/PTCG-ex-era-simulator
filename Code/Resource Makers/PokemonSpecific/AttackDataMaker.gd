extends Resource
class_name AttackData

##If this is true, then the [member prompt] must be true before dealing any dmg 
@export var prompt_reliant: bool = false
@export var prompt: PromptAsk
##Dmg that displays on the main card info next to name
@export_range(0,200,10) var initial_main_DMG: int = 0

@export_group("Ignore")
##Don't check any of these if they're checked
@export_flags("Body", "Weakness", "Resistance", "Effects") var defender_properties: int = 0
##The pokemon can use this attack even if it has these conditions
@export_flags("None", "Paralysis", "Alseep", "Confusion") var condition: int = 1

@export_group("Effects")
@export var ask: SlotAsk
##If [member prompt] and [member ask] are true then this effect will occur
@export var success_effect: EffectCall
##If [member prompt] and [member ask] are false then this effect will occur
@export var fail_effect: EffectCall
##This effect will always occur no matter [member prompt] and [member ask]
@export var always_effect: EffectCall

@export_group("More Damage")
@export_subgroup("Self Damage")
##If this is true then dmg can be increased/activated depending on [member prompt] and [member ask]
##[br]Otherwise the pokemon will take this dmg after attacking
@export var conditional_self_dmg: bool = false
@export_range(0,200,10) var self_damage: int = 0
@export_subgroup("Modifier")
##If this is [code]true[/code], then the result of prompt will multiply the modifier based on prompt result
@export var mod_prompt: bool = false
##[member comparator] * [member prompt] will be multiplied by [member modifier_num] then...
##[br][enum None] - Use [member initial_main_DMG] as is or modified damage if [member prompt]/[member comparator] fails
##[br][i]This depends on if [member mod_prompt] is true or not[/i]
##[br][enum Add] - use [member initial_main_DMG] then add damage depending from modified damage
##[br][enum Multiply] - use modified damage as the result
##[br][enum Subtract] - use [member initial_main_DMG] then subtract damage depending from modified damage
@export_enum("None", "Add", "Multiply", "Subtract") var modifier: int = 0
##When the comparator returns, how much will it be multiplied by?
@export_range(0,200,10) var modifier_num: int = 0
##Determines how damage should be changed
##[br][i]If modifieer is none, this can replace [member initial_main_DMG]
@export var comparator: Comparator
@export_group("Alt Targetting")
##Does this attack hit both defending pokemon in doubles?
@export var both_active: bool = false
@export var bench_damage: BenchAttk

func print_data():
	print_rich("[center]------------------DAMAGE------------------")
	var icon: String
	match modifier:
		1: icon = "+"
		2: icon = "x"
		3: icon = "-"
	print_rich("DAMAGE: ", initial_main_DMG,icon)
	if both_active:
		print_rich("[i]Hits both Active Defending Pokemon")
	if self_damage != 0:
		print_rich("HAS SELF DAMAGE: ", self_damage)
	if bench_damage:
		print_rich("HAS BENCH DAMAGE")
	
	print_rich("[center]------------------IGNORE------------------")
	if defender_properties & 1 != 0: print_rich("Ignore any body effects")
	if defender_properties & 2 != 0: print_rich("Ignore weakness")
	if defender_properties & 4 != 0: print_rich("Ignore resistance")
	if defender_properties & 8 != 0: print_rich("Ignore Applied effects")
	
	if condition & 1 != 0: print_rich("Can use when Asleep")
	if condition & 2 != 0: print_rich("Can use when Paralyzed")
	if condition & 4 != 0: print_rich("Can use when Confused")
	
	var contains: String = ""
	if fail_effect:
		contains += "A Fail Effect\n"
	if success_effect:
		contains += "A Success Effect\n"
	if always_effect:
		contains += "An Always Effect\n"
	if contains != "":
		print_rich("[center]------------------EFFECTS------------------")
		print("HAS: ", contains)
