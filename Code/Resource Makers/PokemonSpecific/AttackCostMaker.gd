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

func get_energy_cost_int() -> Array[int]:
	return [grass_cost, fire_cost, water_cost,
	lightning_cost, psychic_cost, fighting_cost, darkness_cost,
	metal_cost, colorless_cost]
