@tool
extends Resource
class_name AttackCost

@export_range(0,20,1) var grass_cost: int = 0
@export_range(0,20,1) var fire_cost: int = 0
@export_range(0,20,1) var water_cost: int = 0
@export_range(0,20,1) var lightning_cost: int = 0
@export_range(0,20,1) var psychic_cost: int = 0
@export_range(0,20,1) var fighting_cost: int = 0
@export_range(0,20,1) var darkness_cost: int = 0
@export_range(0,20,1) var metal_cost: int = 0
@export_range(0,20,1) var colorless_cost: int = 1
@export_tool_button("Describe") var button: Callable = describe

func get_energy_cost_int() -> Array[int]:
	return [grass_cost, fire_cost, water_cost,
	lightning_cost, psychic_cost, fighting_cost, darkness_cost,
	metal_cost, colorless_cost]

func describe() -> String:
	var cost_str: String = ""
	var cost_arr: Array[int] = get_energy_cost_int()
	for i in range(cost_arr.size()):
		for j in range(cost_arr[i]):
			cost_str += str("{",Consts.energy_types[i],"}")
	
	cost_str = Convert.reformat(cost_str)
	print_rich(cost_str)
	
	return cost_str
