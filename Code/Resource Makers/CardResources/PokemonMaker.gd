extends Resource
class_name Pokemon

@export_group("Stats")
@export_range(10,200,10) var HP: int = 30
@export_range(0,6) var retreat: int = 0

@export_group("Actions")
@export var body: PokeBody
@export var power: PokePower
@export var attacks: Array[Attack] = []

@export_group("Properties")
@export_enum("Basic", "Stage 1", "Stage 2") var evo_stage: String = "Basic"
@export var evolves_from: String = ""
@export_flags("ex", "Baby", "Delta", "Star") var considered: int = 0
@export_enum("None","Team Aqua","Team Magma","Team Rocket", "Holon") var owner: int = 0

@export_group("Type")
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 1

@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var weak: int = 0

@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var resist: int = 0
