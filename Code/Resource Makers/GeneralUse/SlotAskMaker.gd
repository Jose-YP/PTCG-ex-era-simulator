extends Resource
class_name SlotAsk

##If this ask isn't met, look for the next ask
@export var or_ask: SlotAsk
##Check thee last source target stack for whatever they have
@export var previous_src_trg: bool = false
##Which side to pay attention to
@export var side_target: Consts.SIDES = Consts.SIDES.BOTH
@export var slot_target: Consts.SLOTS = Consts.SLOTS.ALL
@export var specifically: Array[String] = []
@export var check_ability: bool = false
@export_flags("Body", "Power") var contained_abilities: int = 3
@export var knocked_out: bool = false
@export var desired_condition: Condition
##Self means the attacking/defending pokemon, Active is for doubles
@export var tool_attatched: bool = false
@export_enum("LessEq", "GreaterEq") var comparison_type: int = 1

@export_subgroup("Stats")
@export_range(-10,200,10) var max_hp: int = -10
@export_range(-10,200,10) var damage_taken: int = -10
##-1 means don't look at it
@export_range(-1, 6, 1) var retreat_cost: int = -1

@export_subgroup("Class")
@export_flags("Basic", "Stage 1", "Stage 2") var stage: int = 7
##Will use later when implementing rare candy
@export var rare_candy: bool = false
##Only including specified classes or excluding specified
@export var class_inclusive: bool = true
@export_flags("non-ex", "ex", "Baby", "Delta", "Star", 
"Dark") var pokemon_class: int = 63
@export var owner_inclusive: bool = true
@export_flags("None", "Aqua", "Magma", "Rocket", "Holon") var pokemon_owner: int = 31
@export_subgroup("Type")
##Check if the pokemon has this type
@export var type_inclusive: bool = true
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var pokemon_type: int = 1023
@export_group("Energy Attatched")
##Look for energy that is of the specified type or ones that aren't
@export var energy_inclusive: bool = true
##If this is true it will count the number of energy cards
##instead of the number of effective energy
@export var check_cards: bool = true
##How much of [member energy_type] energy there is[br]
##Make -1 to indicate that it shouldn't be checked
@export var energy_attatched: int = -1
@export_enum("Basic Energy","Special Energy","Any") var energy_class: String = "Any"
@export var energy_type: EnData = load("res://Resources/Components/EnData/Rainbow.tres")

#Checks if one slot is 
func check_ask(slot: PokeSlot) -> bool:
	var result: bool
	if not slot.is_filled(): return false
	
	#Find which pokemon to check
	print_verbose("[center]",slot.get_card_name())
	#Check if the slot being seen should even be targetted
	#Meanwhile count the player and opp bench size
	print_verbose("[center]-----------------------------------------------------------")
	print_verbose("[center]Target")
	print_verbose("[center]IN SLOT & SIDE: ", slot.is_in_slot(side_target, slot_target))
	
	#First remove any cards that aren't included in sides/slots parameters
	if not slot.is_in_slot(side_target, slot_target):
		return false
	
	#Check if the pokemon matches the desired stage
	print_verbose("[center]-----------------------------------------------------------")
	print_verbose("[center]Evolution")
	print_verbose("[center]",slot.evolved_from.size(), 2 ** slot.evolved_from.size(), 2 ** slot.evolved_from.size() && stage)
	if 2 ** slot.evolved_from.size() & stage:
		#First thing checked, so it doesn't need to account for anything else
		result = true
	
	#Check if the pokemon is in the defined class
	print_verbose("[center]-----------------------------------------------------------")
	print_verbose("[center]Class Flag\nCONSIDERED & OWNER:",
	slot.current_card.pokemon_properties.considered, "|", 2 ** slot.current_card.pokemon_properties.owner)
	print_verbose("OWNER CHECK: ", pokemon_owner, " CLASS CHECK: ", pokemon_class)
	
	print_verbose(slot.current_card.pokemon_properties.owner, 2 ** slot.current_card.pokemon_properties.owner)
	print_verbose(pokemon_class & slot.current_card.pokemon_properties.considered)
	print_verbose(2 ** slot.current_card.pokemon_properties.owner & pokemon_owner != 0)
	#This is because godot has no xor/xnor :(
	var class_flag = (pokemon_class & slot.current_card.pokemon_properties.considered != 0) == class_inclusive
	var owner_flag = (2 ** slot.current_card.pokemon_properties.owner & pokemon_owner != 0) == owner_inclusive
	
	print_verbose("CLASS FLAG: ",class_flag)
	print_verbose("OWNER FLAG: ", owner_flag)
	result = result and class_flag and owner_flag
	#if slot.current_card.pokemon_properties.considered:
		#result = true
	
	#If it is, inlcude it if inclusive class
	#If it isn't include it if exclusive class
	#inclusive class xor~ inside class
	
	print_verbose("[center]-----------------------------------------------------------")
	print_verbose("[center]Type Flag")
	#Check if the pokemon is type inclusive xor~ type
	var types: Array[String] = Convert.flags_to_type_array(slot.current_card.pokemon_properties.type)
	var type_str: String = "[center]Type: "
	for loc_type in types:
		type_str +=  Convert.get_type_rich_color(loc_type) + loc_type + "[/color]"
	print_verbose(type_str, "\n", slot.current_card.pokemon_properties.type && pokemon_type, 
	 not (slot.current_card.pokemon_properties.type && pokemon_type != 0 and not type_inclusive))
	
	var type_bool: bool = not(slot.current_card.pokemon_properties.type && pokemon_type != 0 and not type_inclusive)
	if not type_bool: return false
	result = type_bool and result
	#To Activate
	#Who should be checked
	if max_hp != -10:
		print_verbose("[center]-----------------------------------------------------------")
		print_verbose("[center]Max HP")
		print_verbose("Damage Counters: ", slot.current_card.pokemon_properties.HP)
		var viewing_hp: int = slot.current_card.pokemon_properties.HP
		var hp: bool = viewing_hp >= max_hp if comparison_type == 1 else viewing_hp <= comparison_type
		result = hp and result
	
	#If damage_taken isn't -10 check if a pokemon has taken damage
	if damage_taken != -10:
		print_verbose("[center]-----------------------------------------------------------")
		print_verbose("[center]Damage Taken")
		print_verbose("Damage Counters: ", slot.damage_counters)
		var dmg: bool = slot.damage_counters >= damage_taken if comparison_type == 1 else slot.damage_counters <= damage_taken
		result = dmg and result
	
	if retreat_cost != -1:
		print_verbose("[center]-----------------------------------------------------------")
		print_verbose("[center]Retreat")
		print_verbose("Retreat Cost: ", slot.current_card.pokemon_properties.retreat)
		var cost: bool = (slot.current_card.pokemon_properties.retreat >= retreat_cost
		 if comparison_type == 1 else slot.current_card.pokemon_properties.retreat <= retreat_cost)
		result = cost and result
	
	#If energy attatched isn't -1 check to see if a pokemon has x ammount attatched
	if energy_attatched != -1:
		print_verbose("[center]-----------------------------------------------------------")
		print_verbose("[center]Energy Attatched")
		print_verbose("Check Cards?", energy_class)
		print_verbose("Checking for: ", energy_type.get_string(), " | ", energy_class)
		
		var using = slot.energy_cards if energy_class != "Any" else slot.get_total_en_categories(energy_class)
		var total: int = using.size() if check_cards else slot.get_total_energy(energy_type, using)
		var passes: bool = total >= energy_attatched if comparison_type == 1 else total <= energy_attatched
		print_verbose("Total: ",total, passes)
		
		result = passes and result
	
	#Check if any desired condition exists in the pokemon
	if desired_condition != null:
		print_verbose("[center]-----------------------------------------------------------")
		print_verbose("[center]Conditions")
		print_verbose(slot.affected_by_condition())
		var affected: bool = slot.affected_by_condition()
		
		result = affected and result
	
	##Check if any pokemon has been knocked out
	#result = result and slot.knocked_out if knocked_out else result
	print_verbose("\nFINAL RESULT FOR ", slot.get_card_name(), result,"\n")
	
	if not result and or_ask: return or_ask.check_ask(slot)
	else: return result
