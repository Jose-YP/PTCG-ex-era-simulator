@icon("res://Art/ProjectSpecific/sword(1).png")
@tool
extends SlotChange
class_name Buff

##If this is stackable or it would never matter ignore this
##This determine what identifies two buffs as the same
##Probably use the res' uid
@export var unstackable_id: String
@export var stackable: bool = false
##If against this type of slot use these buffs, if null return [code]true
@export var against: SlotAsk
##Is it applied before or after weak/res
@export var after_weak_res: bool = true

@export_group("Stat Change")
##Unlike with most resources the ignore value is 0 not -1
@export_enum("Add", "Replace") var operation: String = "Add"
@export_range(-200, 200, 10) var add_hp: int = 0
##How much more damage to target?
@export_range(-200, 200, 10) var attack: int = 0
##How much less damage should be taken from attacks
@export_range(-200, 200, 10) var defense: int = 0
##How mucht to add/subtract from a pokemon's retreat cost?
##If -1 at replace, the new value will be 0
@export_range(-6,6,1) var retreat_change: int = 0
@export_subgroup("Attack Cost")
@export_enum("Add", "Subtract", "Replace") var cost_modifier: String = "Add"
@export var attack_cost: AttackCost
@export_subgroup("Comparator")
@export_flags("HP", "Attack", "Defense", "Retreat") var modify: int = 0
@export var plus: bool
@export var comparator: Comparator

@export_group("Immunities")
##Ignore any conditions if this is true
@export_flags("Poison","Burn","Paralysis", "Sleep", "Confusion") var condition_immune: int = 0
##Stop any effects calls from attack calls if this is true including dmg manip
@export var attack_effect_immune: bool = false
##Immune to regular & bench damage [NOT DAMAGE MANIP EFFECT CALLS]
@export var damage_immune: bool = false
@export var body_immune: bool = false
@export var power_immune: bool = false
@export var trainer_immune: bool = false
@export_subgroup("Weird Immunities")
@export var odd_immunity: bool = false
@export var even_immunity: bool = false

@export_group("Pierce")
@export var weakness: bool
@export var resistance: bool
@export var effects: bool

@export_group("Specifiers")
@export var attack_names: Array[String]

func has_stat(stat: Consts.STAT_BUFFS) -> bool:
	match stat:
		Consts.STAT_BUFFS.ATTACK:
			return attack != 0
		Consts.STAT_BUFFS.DEFENSE:
			return defense != 0
		Consts.STAT_BUFFS.HP:
			return add_hp != 0
		Consts.STAT_BUFFS.RETREAT:
			return retreat_change != 0
	return false

func get_stat(stat: Consts.STAT_BUFFS) -> int:
	var final: int = 0
	match stat:
		Consts.STAT_BUFFS.ATTACK:
			final = attack
		Consts.STAT_BUFFS.DEFENSE:
			final = defense
		Consts.STAT_BUFFS.HP:
			final = add_hp
		Consts.STAT_BUFFS.RETREAT:
			final = retreat_change
	
	if comparator:
		var result: bool = false
		match stat:
			Consts.STAT_BUFFS.ATTACK:
				result = modify & 1 != 0
			Consts.STAT_BUFFS.DEFENSE:
				result = modify & 1 != 0
			Consts.STAT_BUFFS.HP:
				result = modify & 1 != 0
			Consts.STAT_BUFFS.RETREAT:
				result = modify & 1 != 0
		
		if result:
			final += comparator.start_comparision()
	
	return final

#Comparator not supported until I find a card that needs it
func get_cost(name: String) -> Array[int]:
	var final = attack_cost.get_energy_cost_int()
	if attack_names.size() != 0:
		if name in attack_names:
			return final
		else:
			return []
	
	return attack_cost.get_energy_cost_int()

func how_display() -> Dictionary[String, bool]:
	var dict: Dictionary[String, bool]
	#Check Stat changes
	if add_hp != 0:
		dict["HP"] = operation == "Add" and add_hp < 0
		return dict
	if attack != 0:
		dict["Atk"] = operation == "Add" and attack < 0
		return dict
	if defense != 0:
		dict["Def"] = operation == "Add" and defense < 0
		return dict
	if retreat_change != 0:
		dict["Cost"] = operation == "Add" and retreat_change > 0
		return dict
	if attack_cost:
		dict["Cost"] = cost_modifier == "Add"
		return dict
	
	#Check Immunities
	if not condition_immune == 0 or damage_immune\
	 or body_immune or power_immune or trainer_immune\
	 or odd_immunity or even_immunity or attack_effect_immune:
		dict["Def"] = false
		return dict
	
	if weakness or resistance or effects:
		dict["Atk"] = false
		return dict
	
	dict["ETC"] = false
	return dict

func describe() -> String:
	var final: String = str(recieves.print_ask(false)," get ")\
		if self.application == "Side" else ""
	var buffs: Array[String]
	
	if add_hp != 0:
		buffs.append(str("HP ", get_stat_string(add_hp), add_hp))
	if attack != 0:
		buffs.append(str("Attack ", get_stat_string(attack), attack))
	if defense != 0:
		buffs.append(str("Defense ", get_stat_string(attack), defense))
	if retreat_change != 0:
		print(modify, retreat_change)
		buffs.append(str("Retreat Cost ", get_stat_string(attack), 0 if -10 else retreat_change))
	
	if attack_cost:
		var new_cost: String = attack_cost.describe()
		var attack_str: String = "attacks"
		
		if attack_names.size() != 0:
			attack_str = Convert.combine_strings(attack_names, "or")
		
		if cost_modifier == "Replace":
			buffs.append(str("Cost of ", attack_str, " is now ", new_cost))
		elif cost_modifier == "Add":
			buffs.append(str("Cost of ", attack_str, " increased by ", new_cost))
		else:
			buffs.append(str("Cost of ", attack_str, " lowered by ", new_cost))
	
	#Check Immunities
	if not condition_immune == 0:
		var specific: Array[String]
		if condition_immune == 31:
			specific.append(str("all conditions"))
		else:
			if condition_immune & 1:
				specific.append("Poision")
			if condition_immune & 2:
				specific.append("Burn")
			if condition_immune & 4:
				specific.append("Paralysis")
			if condition_immune & 8:
				specific.append("Sleep")
			if condition_immune & 16:
				specific.append("Confusion")
		buffs.append(str("Immune to ", Convert.combine_strings(specific, "and")))
	
	if damage_immune or body_immune or power_immune or trainer_immune\
	 or odd_immunity or even_immunity or attack_effect_immune:
		var specific: Array[String]
		if attack_effect_immune and damage_immune:
			specific.append("direct damage and effcts from attacks")
		elif attack_effect_immune:
			specific.append("effcts from attacks")
		elif damage_immune:
			specific.append("direct damage from attacks")
		if body_immune:
			specific.append("effcts from pokebodies")
		if power_immune:
			specific.append("effcts from pokepowers")
		if trainer_immune:
			specific.append("effects from trainers")
		if odd_immunity:
			specific.append("odd numbered direct damage from attacks")
		if even_immunity:
			specific.append("even numbered direct damage from attacks")
		print("HUH?")
		buffs.append(str("Immune to ", Convert.combine_strings(specific, "and")))
	
	if weakness or resistance or effects:
		var specific: Array[String]
		if weakness:
			specific.append("Weaknesses")
		if resistance:
			specific.append("Resistance")
		if effects:
			specific.append("Effects")
		buffs.append(str("Ignore ", Convert.combine_strings(specific, "and"), " when attacking"))
	
	final += str(Convert.combine_strings(buffs, "and"))
	
	if against:
		final += str(" against ", against.print_ask().to_lower())
	
	print_rich(buffs)
	print_rich(final)
	return final

func get_stat_string(stat: int) -> String:
	if operation == "Add" and stat < 0:
		return "lowered by "
	elif operation == "Add":
		return "increased by "
	return "is now "
