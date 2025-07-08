@tool
@icon("res://Art/ProjectSpecific/car.png")
extends Resource
class_name IndvCounter

#--------------------------------------
#region VARIABLES
#script constants
const pokeSlot = preload("res://Code/Resource Makers/PokemonSpecific/PokeSlotMaker.gd")
const stackRes = preload("res://Code/Resource Makers/GeneralUse/CardStacksMaker.gd")
const which_vars: PackedStringArray = ["Slot", "Stack"]
const en_methods: PackedStringArray = ["Attatched","Excess","Types"]

var slot_instance = pokeSlot.new()
var stack_instance = stackRes.new()
var internal_data = {"which" : 0,
 "slot_vars" : "None", "stack_vars" : "None",
 "ask" : load("res://Resources/Components/Effects/Asks/AnyMon.tres"),
 "en_count_methods" : 0, "cap" : 0}
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
		"type" : TYPE_INT,
		"hint" : PROPERTY_HINT_ENUM,
		"hint_string" : ",".join(which_vars),
		"usage" : PROPERTY_USAGE_DEFAULT
	})
	#Find slot_vars
	if internal_data["which"] == 0:
		props.append({
			"name" : "ask",
			"type" : TYPE_OBJECT,
			"hint" : PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string" : "SlotAsk",
			"usage" : PROPERTY_USAGE_DEFAULT
		})
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
				"type" : TYPE_INT,
				"hint" : PROPERTY_HINT_ENUM,
				"hint_string" : ",".join(en_methods),
				"usage" : PROPERTY_USAGE_DEFAULT
			})
	#Find Stack vars
	else:
		props.append({
			"name" : "stack_vars",
			"type" : TYPE_STRING,
			"hint" : PROPERTY_HINT_ENUM,
			"hint_string" : ",".join(stack_array_names),
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
		"ask": return internal_data["ask"]
		"en_count_methods": return internal_data["en_count_methods"]
		"cap": return internal_data["cap"]
	
	return null

func _property_can_revert(property: StringName):
	if (property == "which" or property == "slot_vars" or property == "stack_vars"
	or property == "ask" or property == "en_count_methods" or property == "cap"):
		return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	match property:
		"which": return 0
		"slot_vars": return "None"
		"stack_vars": return "None"
		"ask": return load("res://Resources/Components/Effects/Asks/AnyMon.tres")
		"en_count_methods": return 0
		"cap": return 0
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

func evaluate():pass
