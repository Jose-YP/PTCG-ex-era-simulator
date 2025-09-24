@icon("uid://de16psjd7mfa")
@tool
extends Resource
class_name SlotAsk

##Should it pass every requirement or at least one?[br]
##Note. Or only begins with the requirements that are in groups
@export_enum("And", "Or") var boolean_type: String = "And"
##Check the last source target stack for whatever they have
@export var previous_src_trg: bool = false
##Which side to pay attention to
@export var side_target: Consts.SIDES = Consts.SIDES.BOTH
@export var slot_target: Consts.SLOTS = Consts.SLOTS.ALL
@export var specifically: Array[String] = []

##Self means the attacking/defending pokemon, Active is for doubles
@export var tool_attatched: bool = false
@export_enum("LessEq", "GreaterEq") var comparison_type: int = 1
@export_tool_button("Check string") var button: Callable = print_ask

#region GROUPED VARS
@export_subgroup("Stats")
@export_range(-10,200,10) var max_hp: int = -10
@export_range(-10,200,10) var damage_taken: int = -10
##-1 means don't look at it
@export_range(-1, 6, 1) var retreat_cost: int = -1

@export_subgroup("Class")
@export_enum("Don't Check", "Non Evolved", "Evolved") var evo_type: String = "Don't Check"
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
##Energy classes will mainly be seen through name
@export_flags("None", "React", "Holon",
 "Magma", "Aqua", "Rocket") var en_group: int = 0
##Look for energy that is of the specified type or ones that aren't
@export var energy_inclusive: bool = true
##If this is true it will count the number of energy cards
##instead of the number of effective energy
@export var check_cards: bool = true
##How much of [member energy_type] energy there is[br]
##Make -1 to indicate that it shouldn't be checked
@export var energy_attatched: int = -1
@export_enum("Basic Energy","Special Energy","Any") var energy_class: String = "Any"
@export var energy_type: EnData

@export_group("Ability")
@export var inclusive_ability: bool = true
@export var check_ability: bool = false
@export_flags("Body", "Power") var contained_abilities: int = 3
@export var specific_abilities: Array[String]

@export_group("Condition")
@export var check_condition: bool = false
@export_flags("Poision", "Burn", "Paralyze",
"Asleep", "Confusion", "Imprision", "Shockwave") var desired_condition: int = 0
@export var knocked_out: bool = false
#endregion

#region ASK BOOLEANS
#Checks if one slot is 
func check_ask(slot: PokeSlot, check_slot_side: bool = true) -> bool:
	var result: bool = true
	if not slot.is_filled(): return false
	
	#Find which pokemon to check
	print_verbose("[center]",slot.get_card_name())
	#First remove any cards that aren't included in sides/slots parameters
	if check_slot_side and not slot.is_in_slot(side_target, slot_target):
		return false
	#Check for any pokemon in the specifically array if it's filled
	if specifically.size() != 0:
		if not slot.get_card_name() in specifically:
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
	
	if pokemon_type != 0 and pokemon_type != 1023:
		result = ask_type(slot) and result
		if not result: return false
	
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
		result = ask_energy(slot) and result
	
	#Check if any desired condition exists in the pokemon
	if check_condition:
		print_verbose("[center]-----------------------------------------------------------")
		print_verbose("[center]Conditions")
		print_verbose(slot.affected_by_condition())
		var affected: bool = slot.affected_by_condition()
		
		result = affected and result
	
	if check_ability:
		if contained_abilities & 1 != 0:
			result = result and ask_ability(slot, true)
		
		if contained_abilities & 2 != 0:
			result = result and ask_ability(slot, false)
		
	
	##Check if any pokemon has been knocked out
	#result = result and slot.knocked_out if knocked_out else result
	print_verbose("\nFINAL RESULT FOR ", slot.get_card_name(), result,"\n")
	
	return result

func ask_type(slot: PokeSlot):
	print_verbose("[center]-----------------------------------------------------------")
	print_verbose("[center]Type Flag")
	#Check if the pokemon is type inclusive xor~ type
	var types: Array[String] = Convert.flags_to_type_array(slot.current_card.pokemon_properties.type)
	var type_str: String = "[center]Type: "
	for loc_type in types:
		type_str +=  Convert.get_type_rich_color(loc_type) + loc_type + "[/color]"
	
	print_verbose(type_str, "\n", slot.current_card.pokemon_properties.type & pokemon_type, 
	 not (slot.current_card.pokemon_properties.type & pokemon_type != 0 and not type_inclusive))
	
	return (slot.current_card.pokemon_properties.type & pokemon_type != 0) == type_inclusive

func ask_energy(slot: PokeSlot) -> bool:
	print_verbose("[center]-----------------------------------------------------------")
	print_verbose("[center]Energy Attatched")
	print_verbose("Check Cards?", check_cards, "\t", energy_class)
	print_verbose(str("Checking for: ", energy_type.get_string()) if energy_type else "")
	
	var using = slot.energy_cards if energy_class == "Any" else slot.get_total_en_categories(energy_class)
	
	if en_group > 0 and en_group < 63:
		#None
		if en_group & 1 != 0:
			pass
		else:
			var filter_out: Array[String]
			if en_group & 2 != 0: filter_out.append("React")
			if en_group & 4 != 0: filter_out.append("Holon")
			if en_group & 8 != 0: filter_out.append("Magma")
			if en_group & 16 != 0: filter_out.append("Aqua")
			if en_group & 32 != 0: filter_out.append("Rocket")
			using = using.filter(func (card: Base_Card): 
				for word in filter_out:
					if card.name.contains(word): return true
				return false)
	
	#This accountf or energy type but not energy category
	var total: int = using.size() if check_cards and not energy_type else slot.get_total_energy(energy_type, using)
	
	print_verbose("Total: ",total)
	return total >= energy_attatched if comparison_type == 1 else total <= energy_attatched

func ask_ability(slot: PokeSlot, body: bool) -> bool:
	var ability: Ability = null
	if contained_abilities & 1 != 0:
		ability = slot.get_pokedata().pokebody
	if ability == null and contained_abilities & 2 != 0:
		ability = slot.get_pokedata().pokepower
	
	var result: bool = ability != null
	if specific_abilities.size() != 0 and result:
		result = (ability.name in specific_abilities) == inclusive_ability
	
	return result
#endregion

func print_ask(include_side: bool = true) -> String:
	#Checklist:
	#@export_subgroup("Class")
	
	#First remove any cards that aren't included in sides/slots parameters
	var comparison: String = "at least " if comparison_type == 1 else " at most "
	var slot_str: String = Convert.slot_into_string(slot_target)
	var side_str: String = str(Convert.side_into_string(side_target).capitalize() if include_side else "", " ")
	var hp_str: String = str(comparison, max_hp, " HP") if max_hp != -10 else ""
	var dmg_str: String = str(comparison, damage_taken, " damage counters") if damage_taken != -10 else ""
	var retr_str: String = str("retreat cost of", comparison, retreat_cost) if retreat_cost != -1 else ""
	var specifc_str: String = Convert.combine_strings(specifically, "and")
	var ko_str: String = "knocked out " if knocked_out else ""
	var tool_str: String = "tool cards attatched" if tool_attatched else ""
	var evo_str: String = ""
	var type_str: String = ""
	var class_str: String = ""
	var owner_str: String = ""
	var en_atch_str: String = ""
	var cond_str: String = ""
	var ability_str: String = ""
	
	if evo_type != "Don't Check":
		evo_str = str(evo_type.to_lower(), " ")
		
		if stage != 0 and stage != 7:
			print(stage)
			if stage & 1 != 0:
				evo_str += "basic "
			if stage & 2 != 0:
				evo_str += "stage 1 "
			if stage & 4 != 0:
				evo_str += "stage 2 "
	
	#Check if the pokemon is in the defined class
	if pokemon_class != 0 and pokemon_class != 63:
		print(pokemon_class)
		var class_arr: String = Convert.combine_flags_to_string(["","ex",
			"baby","δ", "star", "\'dark\'"], pokemon_class)
		
		class_str += str("" if class_inclusive else "non-", class_arr, " ")
	
	if pokemon_owner != 0 and pokemon_owner != 31:
		owner_str += "" if owner_inclusive else "non-"
		if pokemon_owner == 30:
			owner_str += "owner's "
		else:
			owner_str += str(Convert.combine_flags_to_string(["",
				"Aqua","Magma","Rocket","Holon"],pokemon_owner), " ")
	
	if pokemon_type != 0 and pokemon_type != 1023:
		var including: String = "" if type_inclusive else "non-"
		type_str = Convert.combine_flags_to_string(["{Grass}","{Fire}","{Water}",
			"{Lightning}","{Psychic}","{Fighting}","{Darkness}",
			"{Metal}","{Colorless}"], pokemon_type, "and")
		type_str = Convert.reformat(type_str)
		
		type_str = str(including, type_str, " type ")
	
	if class_str and owner_str:
		owner_str += "and "
	
	if energy_attatched != -1:
		en_atch_str += str(comparison, energy_attatched, " ")
		
		if en_group != 0 and en_group != 63 and en_group & 1 == 0:
			en_atch_str += str(Convert.combine_flags_to_string(["","React",
				"Magma", "Aqua", "Rocket"], en_group), " ")
		
		if not energy_inclusive:
			en_atch_str += "non "
		if energy_class == "Basic Energy":
			en_atch_str += "Basic "
		if energy_class == "Special Energy":
			en_atch_str += "Special "
		
		if energy_type.type != 0 and energy_type.type != 511:
			print(energy_type.type)
			en_atch_str += str(energy_type.describe(), " ")
		
		en_atch_str += "Energy "
		if check_cards: en_atch_str += "Card"
		if energy_attatched > 1:
			en_atch_str += "s"
		en_atch_str += " "
		en_atch_str += "Attatched "
	
	if check_condition:
		if desired_condition == 31:
			cond_str += "Conditioned "
		else:
			var cond_arr: Array[String] = ["Poisioned", "Burnt", "Paralyzed",
				"Sleeping", "Confused", "Imprisioned", "Shockwaved"]
			cond_str += str(Convert.combine_flags_to_string(cond_arr, desired_condition), " ").to_lower()
	
	if check_ability:
		if specific_abilities:
			pass
		else:
			if contained_abilities & 1 != 0:
				ability_str += "pokebodies"
			if contained_abilities & 2 != 0:
				if ability_str != "":
					ability_str += " or pokepowers"
				else:
					ability_str += "pokepowers"
	
	if side_target == Consts.SIDES.BOTH and slot_target == Consts.SLOTS.ALL:
		side_str = "Every "
	
	var with_str: String
	if hp_str or dmg_str or retr_str or tool_str or ability_str or en_atch_str:
		with_str = str(" with ",hp_str, dmg_str, retr_str, tool_str,
	 ability_str, en_atch_str)
	
	if specifc_str == "":
		specifc_str = "Pokemon"
	
	var final_string: String = str(side_str, ko_str, evo_str, owner_str, type_str,
	  class_str, slot_str, cond_str, specifc_str, with_str).strip_edges()
	
	print_rich(final_string)
	
	return final_string
