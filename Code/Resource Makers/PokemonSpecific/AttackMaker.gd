extends Resource
class_name Attack

#@export_group("Information")
@export var name: String
@export_multiline var description: String

@export_group("Costs")
@export_range(0,20,1) var grass_cost: int = 0
@export_range(0,20,1) var fire_cost: int = 0
@export_range(0,20,1) var water_cost: int = 0
@export_range(0,20,1) var lightning_cost: int = 0
@export_range(0,20,1) var psychic_cost: int = 0
@export_range(0,20,1) var fighting_cost: int = 0
@export_range(0,20,1) var darkness_cost: int = 0
@export_range(0,20,1) var metal_cost: int = 0
@export_range(0,20,1) var colorless_cost: int = 1

@export_group("Ignore")
##Don't check any of these if they're checked
@export_flags("Body", "Weakness", "Resistance", "Effects") var defender_properties: int = 0
##The pokemon can use this attack even if it has these conditions
@export_flags("Alseep", "Paralysis", "Confusion") var condition: int = 0

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

func print_attack() -> void:
	print_rich("[center]------------------",name,"------------------")
	print_rich("Description: ", description)
	print_rich("[center]------------------COST------------------")
	
	for type in Conversions.get_basic_energy():
		print_cost(type)
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

func print_cost(energy: String):
	var using: int = get_cost(Constants.energy_types.find(energy))
	if using == 0: return
	print_rich(str(Conversions.get_type_rich_color(energy), energy, ":[/color] ", using))

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
	print("CHECK COSTS FOR ", name)
	var all_costs: Array[int] = [grass_cost, fire_cost, water_cost,
	lightning_cost, psychic_cost, fighting_cost, darkness_cost,
	metal_cost, colorless_cost]
	var basic_energy: Array[Base_Card] = slot.get_energy_considered()
	var special_energy: Array[Base_Card] = slot.get_energy_considered(false)
	
	#Edit costs depending on whatever factors
	#Priotitize basic/single type first
	print("ENERGY SORT ", basic_energy)
	for card in basic_energy:
		var index = int((log(float(card.energy_properties.get_current_type())) / log(2)))
		print("Used ", card.name, " for ", Constants.energy_types[index] if all_costs[index] > 0 else "Colorless")
		if all_costs[index] > 0: all_costs[index] -= 1
		else: all_costs[8] -= 1
	
	#Maybe sort based on flag size
	special_energy.sort_custom(func(a: Base_Card,b: Base_Card):\
	 return a.energy_properties.get_current_type() < b.energy_properties.get_current_type())
	print("SPECIAL SORT: ", special_energy)
	for card in special_energy:
		var energy_provide = card.energy_properties.get_current_provide()
		var energy_num: int = energy_provide.number
		print("Using ", card.name, " with ", energy_num, " Energy")
		for i in range(all_costs.size()):
			if all_costs[i] == 0: continue
			var type_flag: int = 2 ** i
			
			if type_flag & energy_provide.type != 0\
			 or Constants.energy_types[i] == "Colorless":
				print(card.name, " for ", Constants.energy_types[i])
				all_costs[i] -= 1
				energy_num -= 1
				if energy_num == 0:
					print("Used up ", card.name)
					special_energy.erase(card)
					break
	
	var final_cost: int = 0
	#How to consider special energy later
	for cost in all_costs:
		final_cost += cost
	
	if final_cost > 0:
		print(" LEFTOVER: ", final_cost)
	
	return final_cost

##Checks if the provided energy is enough to cover for the attack cost[br]
##This function prioritizes using basic energy first to optimize energy spending[br]
##ex. [i] [Grass, Darkness] [Rainbow][/i][br] for an attack that costs
## [i][Grasss, Grass, Darkness] [/i] [br]
##It will fill in every cost it can without using multicolor energy only using when necessary.
##Special energy is sorted based on how many colors it can fill in Rainbow > Aqua & Magma
func can_pay(slot: PokeSlot) -> bool:
	return true if pay_cost(slot) == 0 else false

func get_cost(index: int) -> int:
	match index:
		0: return grass_cost
		1: return fire_cost
		2: return water_cost
		3: return lightning_cost
		4: return psychic_cost
		5: return fighting_cost
		6: return darkness_cost
		7: return metal_cost
		8: return colorless_cost
	
	return - 11
