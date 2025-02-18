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
@export var delta: bool = false
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

func type_flags_to_array(property:int) -> Array[String]:
	var list: Array[String] = []
	
	if property & 1:
		list.append("Grass")
	if property & 2:
		list.append("Fire")
	if property & 4:
		list.append("Water")
	if property & 8:
		list.append("Lightning")
	if property & 16:
		list.append("Psychic")
	if property & 32:
		list.append("Fighting")
	if property & 64:
		list.append("Darkness")
	if property & 128:
		list.append("Metal")
	if property & 256:
		list.append("Colorless")
	
	return list
