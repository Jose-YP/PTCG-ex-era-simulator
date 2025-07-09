@tool
@icon("res://Art/ProjectSpecific/car.png")
extends Resource
class_name IndvCounter

#--------------------------------------
#region VARIABLES
#script constants
const pokeSlot = preload("res://Code/Resource Makers/PokemonSpecific/PokeSlotMaker.gd")
const stackRes = preload("res://Code/Resource Makers/GeneralUse/CardStacksMaker.gd")
const which_vars: PackedStringArray = ["Slot", "Stack", "Coinflip"]
const en_methods: PackedStringArray = ["Attatched","Excess","Types"]

var slot_instance = pokeSlot.new()
var stack_instance = stackRes.new()
var internal_data = {"which" : "Slot",
 "slot_vars" : "None", "stack_vars" : "None",
 "coin_flip" : load("res://Resources/Components/CoinFlip/FlipOnce.tres"),
 "ask" : load("res://Resources/Components/Effects/Asks/AnyMon.tres"),
 "en_count_methods" : "Attatched", "cap" : -1}
#endregion
#--------------------------------------

#--------------------------------------
func _get_property_list() -> Array[Dictionary]:
	#region GATHER INFO
	var props: Array[Dictionary] = []
	var slot_array_names: PackedStringArray = ["None"]
	var stack_array_names: PackedStringArray = ["None"]
	var res_prop_list = ClassDB.class_get_property_list("Resource")
	#Collect the name of every property that's in a poke_slot
	for p in slot_instance.get_property_list():
		if (p.has("usage") and p.usage & PROPERTY_USAGE_DEFAULT
		 and p.name not in slot_array_names and not p in res_prop_list):
			slot_array_names.append(p.name)
	
	#Only get the variables that are defined as variables without exports
	#These are the stacks that get used during play
	for p in stackRes.new().get_property_list():
		if (p.has("usage") and p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE and
		 not p.usage & PROPERTY_USAGE_DEFAULT and p.name not in stack_array_names):
			stack_array_names.append(p.name)
	#endregion
	
	#region ESTABLISH PROPERTIES
	props.append({
		"name" : "which",
		"type" : TYPE_STRING,
		"hint" : PROPERTY_HINT_ENUM,
		"hint_string" : ",".join(which_vars),
		"usage" : PROPERTY_USAGE_DEFAULT
	})
	#I'll always need ask for at least defining side to check
	props.append({
			"name" : "ask",
			"type" : TYPE_OBJECT,
			"hint" : PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string" : "SlotAsk",
			"usage" : PROPERTY_USAGE_DEFAULT
	})
	#Find slot_vars
	if internal_data["which"] == "Slot":
		#Append their names into an enum to select from
		props.append({
			"name" : "slot_vars",
			"type" : TYPE_STRING,
			"hint" : PROPERTY_HINT_ENUM,
			"hint_string" : ",".join(slot_array_names),
			"usage" : PROPERTY_USAGE_DEFAULT
			})
		if internal_data["slot_vars"] == "energy_cards":
			#Slot specific count methods
			props.append({
				"name" : "en_count_methods",
				"type" : TYPE_STRING,
				"hint" : PROPERTY_HINT_ENUM,
				"hint_string" : ",".join(en_methods),
				"usage" : PROPERTY_USAGE_DEFAULT
			})
	#Find Stack vars
	elif internal_data["which"] == "Stack":
		props.append({
			"name" : "stack_vars",
			"type" : TYPE_STRING,
			"hint" : PROPERTY_HINT_ENUM,
			"hint_string" : ",".join(stack_array_names),
			"usage" : PROPERTY_USAGE_DEFAULT
		})
	#Find Coin flip
	elif internal_data["which"] == "Coinflip":
		props.append({
			"name" : "coin_flip",
			"type" : TYPE_OBJECT,
			"hint" : PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string" : "CoinFlip",
			"usage" : PROPERTY_USAGE_DEFAULT
		})
	props.append({
		"name" : "cap",
		"type" : TYPE_INT,
		"usage" : PROPERTY_USAGE_DEFAULT
	})
	#endregion
	
	return props
#--------------------------------------

#--------------------------------------
#region GET FUNCTIONS
func _get(property):
	match property:
		"which": return internal_data["which"]
		"slot_vars": return internal_data["slot_vars"]
		"stack_vars": return internal_data["stack_vars"]
		"coin_flip": return internal_data["coin_flip"]
		"ask": return internal_data["ask"]
		"en_count_methods": return internal_data["en_count_methods"]
		"cap": return internal_data["cap"]
	
	return null

func _property_can_revert(property: StringName):
	if (property == "which" or property == "slot_vars" or property == "stack_vars"
	or property == "coin_flip" or property == "ask" or property == "en_count_methods"
	or property == "cap"):
		return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	match property:
		"which": return "Slot"
		"slot_vars": return "None"
		"stack_vars": return "None"
		"coin_flip": return load("res://Resources/Components/CoinFlip/FlipOnce.tres")
		"ask": return load("res://Resources/Components/Effects/Asks/AnyMon.tres")
		"en_count_methods": return "Attatched"
		"cap": return -1
	return null
#endregion
#--------------------------------------

#--------------------------------------
func _set(property, value):
	match property:
		"which":
			internal_data["which"] = value
			notify_property_list_changed()
			return true
		"slot_vars": 
			internal_data["slot_vars"] = value
			notify_property_list_changed()
			return true
		"stack_vars": 
			internal_data["stack_vars"] = value
			return true
		"coin_flip":
			internal_data["coin_flip"] = value
		"ask": 
			internal_data["ask"] = value
			return true
		"en_count_methods": 
			internal_data["en_count_methods"] = value
			return true
		"cap": 
			internal_data["cap"] = value
			return true
	
	return false
#--------------------------------------

func evaluate() -> int:
	var result: int = 0
	
	match internal_data["which"]:
		"Slot":
			result = slot_evaluation(internal_data["slot_vars"], internal_data["ask"])
		"Stack":
			result = stack_evaluation(internal_data["stack_vars"], internal_data["ask"])
		"Coinflip":
			result = coinflip_evaluation(internal_data["coin_flip"])
	
	if internal_data["cap"] != -1:
		result = clamp(result, 0, internal_data["cap"])
	
	return result

func slot_evaluation(slot_data: String, ask_data: SlotAsk) -> int:
	var result: int = 0
	var poke_slots: Array[PokeSlot] = Globals.full_ui.get_poke_slots(Constants.SIDES.BOTH)
	var filtered_slots: Array[PokeSlot] = []
	for slot in poke_slots:
		if ask_data.check_ask(slot):
			filtered_slots.append(slot)
	#For now .filter doesn't work here so.....
	#print("a:", poke_slots.filter(func (slot: PokeSlot): not ask_data.check_ask(slot)))
	#print("B:", poke_slots.filter(func (slot: PokeSlot): ask_data.check_ask(slot)))
	
	for slot in filtered_slots:
		print(slot, slot.get(slot_data))
		if slot_data == "energy_cards":
			result += energy_card_evaluation(internal_data["en_count_methods"], slot)
		else:
			var data = slot.get(slot_data)
			if data is Array:
				result += data.size()
			#This is here for counting number of pokemon as it will use current_card instead of an int
			elif not data is int and data != null:
				result += 1
			else:
				result += slot.get(slot_data)
	
	return result

func energy_card_evaluation(en_count_methods_data: String, slot: PokeSlot):
	print("Using ENERGY COUNT")
	match en_count_methods_data:
		"Attatched":
			return slot.get_total_energy()
		"Excess":
			return slot.get_energy_excess()
		"Types":
			return slot.count_diff_energy()

func stack_evaluation(stack_data: String, ask_data: SlotAsk) -> int:
	print("STACK EVALUATION")
	print(stack_data, ask_data)
	var fundies: Fundies = Globals.fundies
	if ask_data.side_target == Constants.SIDES.BOTH:
		var atk_stack: CardStacks = fundies.stack_manager.get_stacks(fundies.get_considered_home(Constants.SIDES.ATTACKING))
		var def_stack: CardStacks = fundies.stack_manager.get_stacks(fundies.get_considered_home(Constants.SIDES.DEFENDING))
		print(atk_stack, def_stack, stack_data)
		return atk_stack.get(stack_data).size() + def_stack.get(stack_data).size()
	else:
		var stacks: CardStacks = fundies.stack_manager.get_stacks(fundies.get_considered_home(ask_data.side_target))
		print(stacks, stack_data, stacks.get(stack_data))
		return stacks.get(stack_data).size()

func coinflip_evaluation(coinflip_data: CoinFlip):
	print(coinflip_data)
