extends Resource
class_name SlotAsk

@export_group("To Activate")
##If this ask isn't met, look for the next ask
@export var or_ask: SlotAsk
##Which side to pay attention to
@export var side_target: Constants.SIDES = Constants.SIDES.BOTH
@export var slot_target: Constants.SLOTS = Constants.SLOTS.ALL
##-10 means don't look at this var, 0 means must be undamaged, the rest mean x or more
@export_enum("LessEq", "GreaterEq") var comparison_type: int = 1
@export_range(-10,200,10) var max_hp: int = -10
@export_range(-10,200,10) var damage_taken: int = -10
##-1 means don't look at it
@export_range(-1, 6, 1) var retreat_cost: int = -1
##-1 means don't look at this var, 0 means must have no energy, the rest mean x or more
@export var energy_attatched: int = -1
@export var knocked_out: bool = false
@export_flags("Poison", "Burn", "Paralysis", "Asleep", "Confusion") var condition: int = 0
##Self means the attacking/defending pokemon, Active is for doubles
@export_flags("Bench", "Active", "Self", "Discard", "Hand") var location: int = 0 
@export var tool_attatched: bool = false

@export_subgroup("Class")
@export_flags("Basic", "Stage 1", "Stage 2") var stage: int = 7
##Will use later when implementing rare candy
@export var rare_candy: bool = false
##Only including specified classes or excluding specified
@export var class_inclusive: bool = true
@export_flags("non-ex", "ex", "Baby", "Delta", "Star", 
"Dark") var pokemon_class: int = 63
@export var owner_inclusive: bool = true
@export_flags("Magma", "Aqua", "Rocket") var pokemon_owner: int = 15
@export_subgroup("Bench")
##Look for 
@export_range(-1,5) var bench_size: int = -1
@export_subgroup("Type")
##Check if the pokemon has this type
@export var type_inclusive: bool = true
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 1023
@export_enum("Basic","Special","Both") var energy_class: int = 2
##I'm guessing this is about how much of x energy there is
##Make -1 to indicate that it shouldn't be checked
@export var type_size: int = -1

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
	
	#First remove any cards that aren't included in sides/slots parameters
	if not side_target == Constants.SIDES.BOTH or side_target == Constants.SIDES.NONE\
	or (slot.in_attacking_turn and side_target == Constants.SIDES.DEFENDING) \
	or (not slot.in_attacking_turn and side_target == Constants.SIDES.ATTACKING):
		return false
	elif not slot_target == Constants.SLOTS.ALL or slot_target == Constants.SLOTS.NONE\
	or (slot_target == Constants.SLOTS.ACTIVE and not slot.is_active())\
	or (slot_target == Constants.SLOTS.BENCH and slot.is_active())\
	or (slot.is_target and Constants.SLOTS.TARGET):
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
	var class_flag = slot.current_card.pokemon_properties.considered ** 2 & slot.current_card.pokemon_properties.owner ** 2
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
	if max_hp != -10:
		print("-----------------------------------------------------------")
		print_rich("[center]Max HP")
		print("Damage Counters: ", slot.pokedata.HP)
		var viewing_hp: int = slot.pokedata.HP
		var hp: bool = viewing_hp >= max_hp if comparison_type == 1 else viewing_hp <= comparison_type
		result = result and hp
	
	#If damage_taken isn't -10 check if a pokemon has taken damage
	if damage_taken != -10:
		print("-----------------------------------------------------------")
		print_rich("[center]Damage Taken")
		print("Damage Counters: ", slot.damage_counters)
		var dmg: bool = slot.damage_counters >= damage_taken if comparison_type == 1 else slot.damage_counters <= damage_taken
		result = result and dmg
	
	if retreat_cost != -1:
		print("-----------------------------------------------------------")
		print_rich("[center]Retreat")
		print("Retreat Cost: ", slot.pokedata.retreat)
		var cost: bool = slot.pokedata.retreat >= retreat_cost if comparison_type == 1 else slot.pokedata.retreat <= retreat_cost
		result = cost and result
	
	#If energy attatched isn't -1 check to see if a pokemon has x ammount attatched
	if energy_attatched != -1:
		print("-----------------------------------------------------------")
		print_rich("[center]Energy Attatched")
		slot.count_energy()
		result = result and slot.energy_array.size()
	
	#Check if any desired condition exists in the pokemon
	if condition != 0:
		print("-----------------------------------------------------------")
		print_rich("[center]Conditions")
		print("Poision: ", slot.poison_condition, "
		Burn: ", slot.burn_condition,"
		Turn: ", slot.turn_condition)
		var affected: bool = true
		print(slot.poison_condition, slot.burn_condition, slot.turn_condition)
		if slot.poison_condition != 0:
			print("Is ", slot.name, " Poisioned? ", condition & 1)
			affected = condition & 1 or affected
		if slot.burn_condition != 0:
			print("Is ", slot.name, " Burnt? ", condition & 2)
			affected = condition & 2 or affected
		if slot.turn_condition != 0:
			if condition & 4:
				print("Is ", slot.name, " Paralyzed? ", slot.turn_condition == 1)
				affected = slot.turn_condition == 1 or affected
			if condition & 8:
				print("Is ", slot.name, " Asleep? ", slot.turn_condition == 2)
				affected = slot.turn_condition == 2 or affected
			if condition & 16:
				print("Is ", slot.name, " Confused? ", slot.turn_condition == 3)
				affected = slot.turn_condition == 3 or affected
		
		result = affected and result
	
	#Check if any pokemon has been knocked out
	result = result and slot.knocked_out if knocked_out else result
	
	if not result and or_ask: return or_ask.check_ask(slot)
	else: return result
