extends Resource
class_name Attack

@export var name: String
@export_multiline var description: String
@export var attack_cost: AttackCost = preload("res://Resources/Components/Pokemon/Attacks/AttackCosts/Colorless1.tres")
@export var attack_data: AttackData = preload("res://Resources/Components/Pokemon/Attacks/AttackData/10Dmg.tres")

func print_attack() -> void:
	print_rich("[center]------------------",name,"------------------")
	print_rich("Description: ", description)
	print_rich("[center]------------------COST------------------")
	
	for type in Convert.get_basic_energy():
		print_cost(type)
	attack_data.print_data()

func print_cost(energy: String):
	var using: int = get_cost(Consts.energy_types.find(energy))
	if using == 0: return
	print_rich(str(Convert.get_type_rich_color(energy), energy, ":[/color] ", using))

func get_damage() -> int:
	var data: AttackData = attack_data
	var final_damage: int = data.initial_main_DMG
	var mod_times: Variant
	var modifier_result: int = 0
	
	if data.comparator:
		mod_times = data.comparator.start_comparision()
		print("HAS A MODIFIER WITH THE RESULT OF ", data.mod_times, " * ", data.modifier_num)
		if data.comparator.has_coinflip():
			await SignalBus.finished_coinflip
	if data.mod_prompt:
		mod_times = data.prompt_hold
	
	if mod_times is bool:
		mod_times *= 1 if mod_times else 0
	
	if mod_times != null:
		modifier_result = data.modifier_num * mod_times
		match data.modifier:
			1:
				final_damage += modifier_result
			3:
				final_damage -= modifier_result
			_:
				final_damage = modifier_result
	
	return final_damage

##Returns only the specified required energy for the attack to start 
func get_energy_cost() -> Array[String]:
	var all_costs: Array[int] = attack_cost.get_energy_cost_int()
	var final_array: Array[String] = []
	
	for i in range(all_costs.size()):
		var energy_type: String = Consts.energy_types[i]
		for j in range(all_costs[i]):
			final_array.append(energy_type)
	
	return final_array

func pay_cost(slot: PokeSlot):
	print("CHECK COSTS FOR ", name)
	var all_costs: Array[int] = attack_cost.get_energy_cost_int()
	var basic_energy: Array[Base_Card] = slot.get_energy_considered()
	var special_energy: Array[Base_Card] = slot.get_energy_considered(false)
	
	#Edit costs depending on whatever factors
	#Priotitize basic/single type first
	print("ENERGY SORT ", basic_energy)
	for card in basic_energy:
		var index = int((log(float(card.energy_properties.get_current_type())) / log(2)))
		print("Used ", card.name, " for ", Consts.energy_types[index] if all_costs[index] > 0 else "Colorless")
		
		if all_costs[index] > 0: all_costs[index] = clamp(all_costs[index]-1, 0, all_costs[index])
		else: all_costs[8] = clamp(all_costs[8]-1, 0, all_costs[8])
	
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
			 or Consts.energy_types[i] == "Colorless":
				print(card.name, " for ", Consts.energy_types[i])
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
	else:
		print(basic_energy, special_energy)
	
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
		0: return attack_cost.grass_cost
		1: return attack_cost.fire_cost
		2: return attack_cost.water_cost
		3: return attack_cost.lightning_cost
		4: return attack_cost.psychic_cost
		5: return attack_cost.fighting_cost
		6: return attack_cost.darkness_cost
		7: return attack_cost.metal_cost
		8: return attack_cost.colorless_cost
	
	return -1

func does_direct_damage() -> bool:
	return attack_data.initial_main_DMG != 0 \
	or attack_data.modifier_num != 0 or attack_data.self_damage != 0

#Check if you're allowed to attack while having this condition
func condition_allows(turn_cond: Consts.TURN_COND) -> bool:
	match turn_cond:
		Consts.TURN_COND.PARALYSIS:
			print(attack_data.condition && 2, attack_data.condition & 2)
			return attack_data.condition & 2 != 0
		Consts.TURN_COND.ASLEEP:
			return attack_data.condition & 4 != 0
		_:
		#For now confusion doesn't block anything,
		#just check if they can attack without condition
			print(attack_data.condition && 1, attack_data.condition & 1, attack_data.condition)
			return attack_data.condition & 1 != 0
