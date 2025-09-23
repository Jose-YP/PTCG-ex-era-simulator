@tool
@icon("uid://de16psjd7mfa")
extends Resource
class_name Identifier

@export_multiline var description: String
##If this is true, remember what has been searched
@export var must_be_different: bool = false
@export_flags("Pokemon", "Trainer", "Energy") var broad_class
##Check for exactly contains or just has contains
@export var exactly: bool = false
@export_enum("Exact", "Contains", "Or") var name_chec: int = 0
@export var name_array: Array[String] = []
@export_enum("LessEq", "GreaterEq") var comparison_type: int = 1
@export_tool_button("Describe") var button: Callable = describe

@export_group("Pokemon Categories")
@export_range(-10, 200, 10) var HP: int = -10
##Search for a mon that evolves from the using mon
@export var evolves_from: bool = false
##This one is special [NOT IMPLEMENTED]
@export var rare_candy: bool = false
@export var inclusive_class: bool = true
@export_flags("non-ex", "ex", "baby", "delta", "star") var poke_class: int = 0
@export_flags("Aqua", "Magma", "Rocket", "Holon") var owner: int = 0
@export_flags("Basic", "Stage 1", "Stage 2") var stage: int = 0
@export_flags("Grass","Fire","Water","Lightning","Psychic",
"Fighting", "Darkness","Metal","Colorless") var type: int = 0 #0 means search doesn't care about type

@export_group("Trainer Categories")
@export_flags("Item", "Supporter",
"Tool", "Stadium", "TM", "RSM") var trainer_classes: int = 0

@export_group("Energy Categories")
@export_flags("Basic", "Special") var energy_class: int = 3
@export var energy_provides: EnData = preload("res://Resources/Components/EnData/Rainbow.tres")

func identifier_bool(card: Base_Card, based_on: Array[PokeSlot] = []) -> bool:
	print("----------------------------------------------------")
	print(card.name, "\n", card.categories)
	var valid: bool = false
	if name_array.size() != 0:
		for name in name_array:
			if name == card.name:
				valid = true
		if not valid: return false
	
	#Only move forward if the card is the correct kind
	if card.categories & broad_class:
		print("Yes it's considered the right class ")
		#Get the results of every applicable identifier
		#Check if every boolean has to be allowed or not
		if card.pokemon_properties and not card.fossil:
			if exactly:
				print("AND BOOL ", and_poke_bool(card, based_on))
				return and_poke_bool(card, based_on)
			else:
				print("OR BOOL ", or_poke_bool(card, based_on))
				return or_poke_bool(card, based_on)
		if card.trainer_properties:
			if trainer_classes != 0:
				print(card.name, " is ", card.trainer_properties.considered)
				var tr_class: int = 0
				match card.trainer_properties.considered:
					"Item":
						tr_class += 2 ** 0
					"Supporter":
						tr_class += 2 ** 1
					"Tool":
						tr_class += 2 ** 2
					"Stadium":
						tr_class += 2 ** 3
					"TM":
						tr_class += 2 ** 4
					"RSM":
						tr_class += 2 ** 5
				
				print("Now is this allowed? ", trainer_classes & tr_class != 0)
				return trainer_classes & tr_class != 0
			else:
				print(" I don't care what this is just say it's good enogh")
				return true
		else:
			var default_prop: EnData = card.energy_properties.fail_provide
			print(energy_provides.type, " ", default_prop.type)
			
			#If looking for any type at all, check if it contains said type
			if energy_provides.type != 511 and not energy_provides.same_type(default_prop):
				print("Not considered the right type")
				return false
			
			print(card.name, " is ", card.energy_properties.considered, " looking for ", energy_class)
			if energy_class == 3: return true
			
			print(energy_class && 1, energy_class && 2, energy_class & 1, energy_class & 2)
			if card.energy_properties.considered == "Basic Energy" and energy_class & 1 != 0:
				print("Looking for Basic so ", energy_class && 1)
				return card.energy_properties.considered == "Basic Energy"
			elif energy_class & 2 != 0:
				print("Looking for Special so ", energy_class && 2)
				return card.energy_properties.considered == "Special Energy"
			else:
				return false
	
	print("Not right category, moving on")
	return false

func or_poke_bool(card: Base_Card, based_on: Array[PokeSlot]) -> bool:
	print("/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\")
	var pokemon: Pokemon = card.pokemon_properties
	
	if HP != -10:
		match comparison_type:
			0:
				if HP < pokemon.HP:
					return false
			1:
				if HP > pokemon.HP:
					return false
	
	#Check if the card evolves from th
	if evolves_from:
		
		var evo_result: bool = false
		for based_on_slot in based_on:
			var based_on_card: Base_Card = based_on_slot.current_card
			if pokemon.evolves_from == based_on_card.name:
				evo_result = true
		print(card.name, evo_result, based_on)
		if evo_result: 
			return true
	
	if type != 0 and pokemon.type & type: return true
	
	if stage != 0:
		var evo: int = 2 ** 0
		match pokemon.evo_stage:
			"Stage 1":
				evo = 2 ** 1
			"Stage 2":
				evo = 2 ** 2
		
		print(pokemon.evo_stage)
		print(evo, stage)
		print(stage & evo)
		if stage & evo != 0: return true
	
	print(poke_class != 0, poke_class & pokemon.considered)
	print(poke_class,"|||", pokemon.considered)
	
	if poke_class != 0 and poke_class & pokemon.considered != 0: return true
	
	if owner != 0 and owner & pokemon.owner != 0: return true
	
	print(card.name, " isn't allowed")
	return false

func and_poke_bool(card: Base_Card, based_on: Array[PokeSlot]):
	print("\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/")
	var pokemon: Pokemon = card.pokemon_properties
	
	if HP != -10:
		match comparison_type:
			0:
				if HP < pokemon.HP:
					return false
			1:
				if HP > pokemon.HP:
					return false
	
	#Check if the card evolves from any card in based_on
	if evolves_from:
		var evo_result: bool = false
		for based_on_slot in based_on:
			var based_on_card: Base_Card = based_on_slot.current_card
			if pokemon.evolves_from == based_on_card.name:
				evo_result = true
		if not evo_result: return false
	
	if type != 0 and not pokemon.type & type: return false
	
	if poke_class != 0 and poke_class & pokemon.considered == 0: return false
	
	if owner != 0 and owner & pokemon.owner == 0: return false
	
	if stage != 0:
		var evo: int = 2 ** 0
		match pokemon.evo_stage:
			"Stage 1":
				evo = 2 ** 1
			"Stage 2":
				evo = 2 ** 2
		
		if not stage & evo == 0: return false
	
	return true

func edit_in_type(type_flags: int):
	type = 0
	type |= type_flags

func describe() -> String:
	var final: String = ""
	
	var to_add: Array[String]
	
	if broad_class & 1 != 0:
		var mon_string: String = ""
		var specifically: String = ""
		var bef_hold: Array[String]
		var after_hold: Array[String]
		
		if HP != -10:
			after_hold.append(str("have ", "at least " if comparison_type else\
				" at most", HP, " HP" ))
		if evolves_from:
			if Engine.is_editor_hint():
				after_hold.append("Evolves from target")
			else:
				pass
		if stage != 0 and stage != 7 and stage != 6:
			bef_hold.append(Convert.combine_flags_to_string(\
				["basic", "stage 1", "stage 2"], stage))
		if poke_class != 0 and poke_class != 31:
			bef_hold.append(str("" if inclusive_class else "non-",
				Convert.combine_flags_to_string(\
				["non-ex", "ex", "baby", "delta", "star"], poke_class)))
		if owner != 0 and owner != 15:
			bef_hold.append(Convert.combine_flags_to_string(\
				["Aqua", "Magma", "Rocket", "Holon"], owner))
		if stage == 6: bef_hold.append("Evolution")
		
		if name_array.size() != 0 and name_chec == 0:
			specifically += Convert.combine_strings(name_array)
		else:
			specifically += "Pokemon"
		mon_string = str(Convert.combine_strings(bef_hold, ""), "" if bef_hold.size() == 0\
		else " ", specifically, "" if after_hold.size() == 0 else\
		 " that " ,Convert.combine_strings(after_hold))
		
		if mon_string != "":
			to_add.append(mon_string)
	
	if broad_class & 2 != 0:
		var train_string: String = ""
		
		if trainer_classes != 0 and trainer_classes != 63:
			train_string = Convert.combine_flags_to_string(["Unlabled", "Supporter",
				"Tool", "Stadium", "TM", "RSM"], trainer_classes)
			train_string += " "
		
		train_string += "Trainer "
		
		if train_string != "":
			to_add.append(train_string)
	
	if broad_class & 4 != 0:
		var en_string: String = ""
		
		match energy_class:
			1:
				en_string = "Basic Energy"
			2:
				en_string = "Special Energy"
			_:
				en_string = "Energy"
		
		if en_string != "":
			to_add.append(en_string)
	
	final = Convert.combine_strings(to_add, "or")
	
	if must_be_different:
		final = str("different types of ", final)
	
	if name_chec != 0:
		final += str("that contains ", Convert.combine_strings(name_array, "or"), " in the name")
	
	if final == "":
		final = "any"
	
	#final += " cards"
	
	print(final)
	return final
