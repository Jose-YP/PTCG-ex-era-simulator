extends Resource
class_name Attack

#@export_group("Information")
@export var name: String
@export_multiline var description: String

@export_group("Costs")
@export var grass_cost: int = 0
@export var fire_cost: int = 0
@export var water_cost: int = 0
@export var lightning_cost: int = 0
@export var psychic_cost: int = 0
@export var fighting_cost: int = 0
@export var darkness_cost: int = 0
@export var metal_cost: int = 0
@export var colorless_cost: int = 1

@export_group("Ignore")
@export_flags("Body","Weakness","Resistance", "All") var defender_properties: int = 0
##The pokemon can use this attack even if it has these conditions
@export_flags("Alseep", "Paralysis", "Confusion") var ignore_condition: int = 0

@export_group("Damage")
##If this is true, then the [member prompt] must be true before dealing any dmg 
@export var prompt_reliant: bool = false
##Dmg that displays on the main card info next to name
@export_range(0,200,10) var initial_main_DMG: int = 0
##If this is true then dmg can be increased/activated depending on [member prompt] and [member ask]
##[br]Otherwise the pokemon will take this dmg after attacking
@export var conditional_self_dmg: bool = false
@export_range(0,200,10) var self_damage: int = 0
@export_enum("None", "Add", "Multiply", "Subtract") var modifier: int = 0
##Does this attack hit both defending pokemon in doubles?
@export var both_active: bool = false
@export var bench_damage: BenchAttk
@export var counter: Counter

@export_group("Effects")
@export var prompt: PromptAsk
@export var ask: SlotAsk
##If [member prompt] and [member ask] are true then this effect will occur
@export var success_effect: EffectCall
##If [member prompt] and [member ask] are false then this effect will occur
@export var fail_effect: EffectCall
##This effect will always occur no matter [member prompt] and [member ask]
@export var always_effect: EffectCall

##Returns only the specified required energy for the attack to start 
func get_energy_cost() -> Array[String]:
	var all_costs: Array[int] = [grass_cost, fire_cost, water_cost,
	lightning_cost, psychic_cost, fighting_cost, darkness_cost,
	metal_cost, colorless_cost]
	var final_array: Array[String] = []
	
	for i in range(all_costs.size()):
		var energy_type: String = Constants.energy_types[i]
		for j in range(all_costs[i]):
			final_array.append(energy_type)
	
	return final_array

##Checks if the provided energy is enough to cover for the attack cost[br]
##This function prioritizes using basic energy first to optimize energy spending[br]
##ex. [i] [Grass, Darkness] [Rainbow][/i][br] for an attack that costs
## [i][Grasss, Grass, Darkness] [/i] [br]
##It will fill in every cost it can without using multicolor energy only using when necessary.
##Special energy is sorted based on how many colors it can fill in Rainbow > Aqua & Magma
func can_pay(basic_energy: Array[int], special_energy: Array[int]) -> bool:
	var all_costs: Array[int] = [grass_cost, fire_cost, water_cost,
	lightning_cost, psychic_cost, fighting_cost, darkness_cost,
	metal_cost, colorless_cost]
	
	#Edit costs depending on whatever factors
	#Priotitize basic/single type first
	print("ENERGY SORT ", basic_energy)
	for card in basic_energy:
		var index = int((log(float(card)) / log(2)))
		print(index)
		if all_costs[index] > 0: all_costs[index] -= 1
		else: all_costs[8] -= 1
	
	#Maybe sort based on flag size
	special_energy.sort_custom(func(a,b): return a[0] < b[0])
	print("SPECIAL SORT: ", special_energy)
	for i in range(all_costs.size()):
		for card in special_energy:
			if i ** 2 & card:
				print(card, " for ", i)
				all_costs[i] -= 1
				special_energy.erase(card)
			if all_costs[i] == 0: 
				print("Satisfied ", i)
				break
	#How to consider special energy later
	for cost in all_costs:
		if cost > 0:
			print(cost, " LEFTOVER: ", all_costs.find(cost))
			return false
	
	return true
