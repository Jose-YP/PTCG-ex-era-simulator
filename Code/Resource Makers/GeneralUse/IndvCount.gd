@tool
@icon("res://Art/ProjectSpecific/car.png")
extends Resource
class_name IndvCounter

#--------------------------------------
#region VARIABLES
#script constants
const pokeSlot = preload("res://Code/Resource Makers/PokemonSpecific/PokeSlotMaker.gd")
const stackRes = preload("res://Code/Resource Makers/GeneralUse/CardStacksMaker.gd")

var slot_instance = pokeSlot.new()
var stack_instance = stackRes.new()
var internal_data = {"slot_arrays" : "None", "stack_properties" : "None",
 "ask" : load("res://Resources/Components/Effects/Asks/AnyMon.tres")}
#endregion
#--------------------------------------

#--------------------------------------
func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary] = []
	var slot_array_names: PackedStringArray = ["None"]
	var stack_array_names: PackedStringArray = ["None"]
	#Collect the name of every property that's an array in a poke_slot
	for p in slot_instance.get_property_list():
		if (p.has("usage") and p.usage & PROPERTY_USAGE_DEFAULT
		 and p.name not in slot_array_names and p.type == TYPE_ARRAY):
			slot_array_names.append(p.name)
	
	#Only get the variables that are defined as variables without exports
	#These are the stacks that get used during play
	for p in stackRes.new().get_property_list():
		if (p.has("usage") and p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE and
		 not p.usage & PROPERTY_USAGE_DEFAULT and p.name not in stack_array_names):
			stack_array_names.append(p.name)
	
	#First property will ask what types of slots will be counted
	props.append({
		"name" : "ask",
		"type" : TYPE_OBJECT,
		"hint" : PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string" : "SlotAsk",
		"usage" : PROPERTY_USAGE_DEFAULT
	})
	#Append their names into an enum to select from
	props.append({
		"name" : "slot_arrays",
		"type" : TYPE_STRING,
		"hint" : PROPERTY_HINT_ENUM,
		"hint_string" : ",".join(slot_array_names),
		"usage" : PROPERTY_USAGE_DEFAULT
		})
	props.append({
		"name" : "stack_properties",
		"type" : TYPE_STRING,
		"hint" : PROPERTY_HINT_ENUM,
		"hint_string" : ",".join(stack_array_names),
		"usage" : PROPERTY_USAGE_DEFAULT
	})
	
	#print(internal_data)
	return props
#--------------------------------------

#--------------------------------------
#region GET FUNCTIONS
func _get(property):
	if property == "slot_arrays":
		return internal_data["slot_arrays"]
	elif property == "stack_properties":
		return internal_data["stack_properties"]
	elif property == "ask":
		return internal_data["ask"]
	return null

func _property_can_revert(property: StringName):
	if (property == "slot_arrays" or property == "stack_properties"
	or property == "ask"):
		return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	if property == "slot_arrays":
		return "None"
	elif property == "stack_properties":
		return "None"
	elif property == "ask":
		#For some reason loading it here works but not outside
		var default_ask: SlotAsk = load("res://Resources/Components/Effects/Asks/AnyMon.tres")
		return default_ask
	return null
#endregion
#--------------------------------------

#--------------------------------------
func _set(property, value):
	if property == "slot_arrays":
		internal_data["slot_arrays"] = value
		return true
	elif property == "stack_properties":
		internal_data["stack_properties"] = value
		return true
	elif property == "ask":
		print(internal_data, value, value.side_target)
		internal_data["ask"] = value
		return true
	return false
#--------------------------------------

func evaluate():pass
