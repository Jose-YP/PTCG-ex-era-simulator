extends Resource
class_name SlotAsk

@export_group("To Activate")
##If this ask isn't met, look for the next ask
@export var or_ask: SlotAsk
##Which side to pay attention to
@export_enum("None", "Player", "Opponent", "Both") var target: int = 0
##-10 means don't look at this var, 0 means must be undamaged, the rest mean x or more
@export_enum("LessEq", "GreaterEq") var damage_comparison: int = 1
@export_range(-10,200,10) var damage_taken: int = -10
##-1 means don't look at this var, 0 means must have no energy, the rest mean x or more
@export var energy_attatched: int = -1
@export var knocked_out: bool = false
@export_flags("Poison", "Burn", "Paralysis", "Asleep", "Confusion") var condition: int = 0
##Self means the attacking/defending pokemon, Active is for doubles
@export_flags("Bench", "Active", "Self", "Discard", "Hand") var location: int = 0 

@export_subgroup("Class")
@export_flags("Basic", "Stage 1", "Stage 2") var stage: int = 7
##Only including specified classes or excluding specified
@export var class_inclusive: bool = true
@export_flags("Baby", "ex", "Delta", "Star",
 "Magma", "Aqua", "Rocket", "Dark") var pokemon_class: int = 0
@export_subgroup("Bench")
##Look for 
@export_range(-1,5) var bench_size: int = -1
@export_subgroup("Type")
##Check if the pokemon has this type
@export var type_inclusive: bool = true
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 1023
##I'm guessing this is about how much of x energy there is
##Make -1 to indicate that it shouldn't be checked
@export var type_size: int = -1

@export_group("Before Activating")
@export_multiline var ask_string: String 
@export var coin_flip: CoinFlip
##Give a prompt asking to activate the effect
@export var formal_ask: bool = false
@export_enum("None", "Player", "Opponent") var choose: int = 0
@export_flags("Bench", "Active", "Self", 
"Discard", "Hand") var choose_location: int = 0

#Checks if one slot is 
func check_ask(slot: PokeSlot) -> bool:
	var result: bool
	
	#Find which pokemon to check
	print_rich("[center]",slot.current_card.name)
	#Check if the slot being seen should even be targetted
	#Meanwhile count the player and opp bench size
	print("-----------------------------------------------------------")
	print_rich("[center]Target")
	print("Player: ", slot.ui_slot.player)
	if slot.ui_slot.player and target == 2 or target == 0:
		return false
	elif target == 1:
		return false

	#Check if the pokemon matches the desired stage
	print("-----------------------------------------------------------")
	print_rich("[center]Evolution")
	print(slot.evolved_from.size(), slot.evolved_from.size() ** 2, slot.evolved_from.size() ** 2 & stage)
	if slot.evolved_from.size() ** 2 & stage:
		#First thing checked, so it doesn't need to account for anything else
		result = true
	
	#Check if the pokemon is in the defined class
	print("-----------------------------------------------------------")
	print_rich("[center]Class Flag")
	print(slot.current_card.pokemon_properties.considered, slot.current_card.pokemon_properties.owner)
	print(slot.current_card.pokemon_properties.considered ** 2, slot.current_card.pokemon_properties.owner ** 2)
	var class_flag = slot.current_card.pokemon_properties.considered ** 2 + slot.current_card.pokemon_properties.owner ** 2
	print("CLASS FLAG: ",class_flag)
	#if slot.current_card.pokemon_properties.considered:
		#result = true
	
	#If it is, inlcude it if inclusive class
	#If it isn't include it if exclusive class
	#inclusive class xor~ inside class
	
	print("-----------------------------------------------------------")
	print_rich("[center]Type Flag")
	#Check if the pokemon is type inclusive xor~ type
	var type_color: String = str("[color=",Constants.energy_colors[log(slot.type) / log(2)].to_html(),"]") 
	print_rich("Type: ", type_color)
	print(((slot.type && type) == type_inclusive))
	
	#To Activate
	#Who should be checked
	#If damage_taken isn't -10 check if a pokemon has taken damage
	if damage_taken != -10:
		print("-----------------------------------------------------------")
		print_rich("[center]Damage Taken")
		print("Damage Counters: ", slot.damage_counters)
		var dmg: bool = slot.damage_counters >= damage_taken if damage_comparison == 1 else slot.damage_counters <= damage_comparison
		result = result and dmg
	
	#If energy attatched isn't -1 check to see if a pokemon has x ammount attatched
	if energy_attatched != -1:
		slot.count_energy()
		result = result and slot.energy_array.size()
	#Check if any desired condition exists in the pokemon
	
	#Check if any pokemon has been knocked out
	# 
	
	#BEFORE ACTIVATIONS
	
	#Ask if an effect should happen
	#formal ask and ask string
	
	#Let the [choose] pick from these options
	#choose location will determine what to choose
	
	if not result and or_ask: return or_ask.check_ask(slot)
	else: return result

func has_coin_flip():
	pass
