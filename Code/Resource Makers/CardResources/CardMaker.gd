extends Resource
class_name Base_Card

@export_category("Information")
@export var name: String
@export var image: CompressedTexture2D
@export var illustrator: String
@export var number: int = 0
@export_enum("Common", "Uncommon", "Rare", "Holofoil Rare", "ex Rare",
"Ultra Rare", "Star Rare", "Promo Rare") var rarity: int = 0
@export_enum("EX Ruby & Sapphire", "EX Sandstorm", "EX Dragon",
"EX Team Magma vs Team Aqua", "EX Hidden Legends", "EX FireRed & LeadGreen",
"EX Team Rocket Returns", "EX Deoxys", "EX Emerald", "EX Unseen Forces",
"EX Delta Species", "EX Legend Maker", "EX Holon Phantoms", "EX Crystal Guardians",
"EX Dragon Frontiers", "EX Power Keepers", "Black Star Promo",
"POP Series 1", "POP Series 2", "POP Series 3",
"POP Series 4", "POP Series 5") var expansion: int = 0

@export_category("Properties")
@export_flags("Pokemon", "Trainer", "Energy") var categories: int = 0
@export var pokemon_properties: Pokemon
@export var trainer_properties: Trainer
@export var energy_properties: Energy
@export var fossil: bool = false

func print_info():
	print("-------------------------", name, "-------------------------")
	print("Illustrator: ", illustrator, "
	Expansion: ", Constants.expansion_abbreviations,"
	Number: ", number, "/", Constants.expansion_counts[expansion],
	"Rarity: ", Constants.rarity[rarity],"\n")
	if pokemon_properties:
		print("-------------------------POKEMON-------------------------")
		pokemon_properties.print_pokemon()
	elif trainer_properties:
		print("-------------------------TRAINER-------------------------")
		trainer_properties.print_trainer()
	elif energy_properties:
		print("-------------------------ENERGY-------------------------")
		energy_properties.print_energy()
	print("-------------------------------------------------------------")

func card_display() -> String:
	if fossil:
		return "Fossil"
	elif pokemon_properties:
		return "Pokemon"
	elif trainer_properties:
		return "Trainer"
	elif energy_properties:
		return "Energy"
	
	push_error(name, " isn't considered anything")
	return "NONE"

func is_considered(considered: String):
	if pokemon_properties:
		#Holon's mons will be considered pokemon before looking at energy properties
		return pokemon_properties.evo_stage == considered
	if trainer_properties and trainer_properties.considered == considered:
		return trainer_properties.considered == considered
	if energy_properties and energy_properties.considered == considered:
		#Energy might need a function for this
		return energy_properties.considered == considered
	
	return false
