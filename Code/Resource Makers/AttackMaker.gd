extends Resource
class_name Attack

@export_group("Information")
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
@export_flags("Alseep", "Paralysis", "Confusion") var ignore_condition: int = 0

@export_group("Damage")
@export_range(0,200,10) var initial_main_DMG: int = 0
@export_enum("None", "Add", "Multiply", "Subtract") var modifier: int = 0

@export var counter: Counter

@export_group("Effects")
@export var ask: Ask
@export var effect: EffectCall
@export var fail_effect: EffectCall
