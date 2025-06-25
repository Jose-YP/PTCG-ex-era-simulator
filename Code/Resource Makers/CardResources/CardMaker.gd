##Holds data every card requires. Metadata and component slots for deeper resources
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
##Allows a card to serve multiple functions, will be important for:
##[br]* Fossil Cards[br]* Holon's Pokemon
@export_flags("Pokemon", "Trainer", "Energy") var categories: int = 0
@export var pokemon_properties: Pokemon
@export var trainer_properties: Trainer
@export var energy_properties: Energy
@export var fossil: bool = false

##Debug funciton, useful for making sure the exact car is known
func print_info() -> void:
	print("-------------------------", name, "-------------------------")
	print("Illustrator: ", illustrator, "
	Expansion: ", Constants.expansion_abbreviations[expansion],"
	Number: ", number, "/", Constants.expansion_counts[expansion],"
	Rarity: ", Constants.rarity[rarity],"\n")
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

##Debug funciton, useful for a quick way to find a card's distinct class
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

func get_considered() -> String:
	if pokemon_properties:
		#Holon's mons will be considered pokemon before looking at energy properties
		return pokemon_properties.evo_stage
	if trainer_properties:
		if trainer_properties.considered == "Supporter":
			return "Support"
		return trainer_properties.considered
	if energy_properties:
		#Energy might need a function for this
		return "Energy"
	
	return "NONE"
##Function used to check what type of functions a card will use
##Prioritizes pokemon properties, then trainer properties and lastly energy properties
func is_considered(considered: String) -> bool:
	if pokemon_properties:
		#Holon's mons will be considered pokemon before looking at energy properties
		return pokemon_properties.evo_stage == considered
	if trainer_properties and trainer_properties.considered == considered:
		return trainer_properties.considered == considered
	if energy_properties and energy_properties.considered == considered:
		#Energy might need a function for this
		return energy_properties.considered == considered
	
	return false

#Lowest number for highest priority
#priority for pokemon  [ex > owner > delta > dark > baby > non > star] > [basic > 1 > 2] > [type]
#For all cards, theree's a tie breaker [name] > [expansion + number]
func card_priority(compared_to: Base_Card) -> bool:
	#Top level priority
	#if they're both pokemon
	if (pokemon_properties and compared_to.pokemon_properties) and not (fossil or compared_to.fossil):
		#If they're equal look at stage
		if pokemon_properties.considered == compared_to.pokemon_properties.considered:
			if pokemon_properties.evo_stage == compared_to.pokemon_properties.evo_stage:
				if pokemon_properties.type == compared_to.pokemon_properties.type:
					return generic_sort(compared_to)
				else:
					return pokemon_properties.type > compared_to.pokemon_properties.type
			else:
				return pokemon_properties.evo_stage > compared_to.pokemon_properties.evo_stage
		else:
			if pokemon_properties.owner != 0 and compared_to.pokemon_properties.owner != 0:
				return pokemon_properties.owner > compared_to.pokemon_properties.owner
			else:
				return pokemon_properties.considered > compared_to.pokemon_properties.considered
	#if only one is a pokemon
	elif (pokemon_properties != null) != (compared_to.pokemon_properties != null):
		return pokemon_properties != null

	#If they're both trainers
	if trainer_properties and compared_to.trainer_properties:
		if fossil != compared_to.fossil:
			return fossil
		
		if trainer_properties.considered == compared_to.trainer_properties.considered:
			return generic_sort(compared_to)
		
		return Constants.trainer_classes.find(trainer_properties.considered)\
		 < Constants.trainer_classes.find(compared_to.trainer_properties.considered)
	elif (trainer_properties != null) != (compared_to.trainer_properties != null):
		return trainer_properties != null
	
	if energy_properties.considered == compared_to.energy_properties.considered:
		if energy_properties.react != compared_to.energy_properties.react:
			return energy_properties.react
		if energy_properties.holon_type != compared_to.energy_properties.holon_type:
			return energy_properties.holon_type > compared_to.energy_properties.holon_type
		if energy_properties.number != compared_to.energy_properties.number:
			return energy_properties.number > compared_to.energy_properties.number
		
		return energy_properties.type > compared_to.energy_properties.type
	else:
		return energy_properties.considered > compared_to.energy_properties.considered

func generic_sort(compared_to: Base_Card) -> bool:
	if compared_to.expansion == expansion:
		return number > compared_to.number
	return compared_to.expansion > expansion

##This function can find the same card regardless of locality
##[br] The same card will always have a unique expansion & number
func same_card(comparing_to: Base_Card) -> bool:
	return (comparing_to.number == number and 
	comparing_to.expansion == expansion)
