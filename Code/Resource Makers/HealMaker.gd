extends Resource
class_name HealEffect

@export_group("Healing")
@export_range(-1,5) var how_many: int = 1
@export_enum("Player","Opponent","All") var which: int = 1
@export_range(0,200,10) var initial_main_NUM: int = 0
@export_enum("None", "Add", "Multiply", "Subtract") var modifier: int = 0
@export var counter: Counter
