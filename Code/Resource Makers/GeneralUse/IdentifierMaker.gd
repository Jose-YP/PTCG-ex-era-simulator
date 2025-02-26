extends Resource
class_name Identifier

@export_category("Specific Categories")
##If this is true, remember what has been searched
@export var must_be_different: bool = false
@export_flags("Pokemon", "Trainer", "Energy") var broad_class
##Check for exactly contains or just has contains
@export var exactly: bool = false
@export var contains: String = ""
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 0 #0 means search doesn't care about type

@export_group("Pokemon Categories")
##Search for a mon that evolves from the using mon
@export var evolves_from: bool = false
@export_flags("non-ex", "ex", "baby", "delta") var poke_class
@export_flags("Aqua", "Magma", "Rocket", "Holon") var owner: int = 0
@export_flags("Basic", "Stage 1", "Stage 2") var stage

@export_group("Trainer Categories")
@export_flags("Item", "Supporter",
"Tool", "Stadium", "TM") var trainer_classes

@export_group("Energy Categories")
@export_flags("Basic", "Special") var energy_class
