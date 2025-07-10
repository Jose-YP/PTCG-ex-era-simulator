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
##None - Use [member initial_main_DMG] as is or damage returned from [member counter] and [member prompt]
##[br]Add - use [member initial_main_DMG] then add damage depending on [member counter] and [member prompt]
##[br]Multiply - use [member initial_main_DMG] times the result found with [member counter] and [member prompt], allows 0 as a result
##[br]Subtract - use [member initial_main_DMG] then add damage depending on [member counter] and [member prompt]
@export_enum("None", "Add", "Multiply", "Subtract") var modifier: int = 0
##Does this attack hit both defending pokemon in doubles?
@export var both_active: bool = false
@export var bench_damage: BenchAttk
##Determines how damage should be changed
##[br][i]If modifieer is none, this can replace [member initial_main_DMG]
@export var comparator: Comparator

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

func pay_cost(slot: PokeSlot):
	var all_costs: Array[int] = [grass_cost, fire_cost, water_cost,
	lightning_cost, psychic_cost, fighting_cost, darkness_cost,
	metal_cost, colorless_cost]
	var basic_energy: Array[Base_Card] = slot.get_energy_considered()
	var special_energy: Array[Base_Card] = slot.get_energy_considered(false)
	
	#Edit costs depending on whatever factors
	#Priotitize basic/single type first
	print("ENERGY SORT ", basic_energy)
	for card in basic_energy:
		var index = int((log(float(card.energy_properties.type)) / log(2)))
		print(index)
		if all_costs[index] > 0: all_costs[index] -= 1
		else: all_costs[8] -= 1
	
	#Maybe sort based on flag size
	special_energy.sort_custom(func(a: Base_Card,b: Base_Card): return a.energy_properties.type < b.energy_properties.type)
	print("SPECIAL SORT: ", special_energy)
	for i in range(all_costs.size()):
		for card in special_energy:
			if i ** 2 & card.energy_properties.type:
				print(card, " for ", i)
				all_costs[i] -= 1
				special_energy.erase(card)
			if all_costs[i] == 0: 
				print("Satisfied ", i)
				break
	
	var final_cost: int = 0
	#How to consider special energy later
	for cost in all_costs:
		final_cost += cost
		if cost > 0:
			print(cost, " LEFTOVER: ", all_costs.find(cost))
	
	return final_cost

##Checks if the provided energy is enough to cover for the attack cost[br]
##This function prioritizes using basic energy first to optimize energy spending[br]
##ex. [i] [Grass, Darkness] [Rainbow][/i][br] for an attack that costs
## [i][Grasss, Grass, Darkness] [/i] [br]
##It will fill in every cost it can without using multicolor energy only using when necessary.
##Special energy is sorted based on how many colors it can fill in Rainbow > Aqua & Magma
func can_pay(slot: PokeSlot) -> bool:
	return true if pay_cost(slot) == 0 else false
