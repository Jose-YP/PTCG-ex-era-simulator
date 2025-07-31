@tool
extends Resource
class_name Occurance

const pokeSlot = preload("res://Code/Resource Makers/PokemonSpecific/PokeSlotMaker.gd")

signal occur

var slot_instance = pokeSlot.new()
var internal_data = { "signal": "checked_up",
 "from_ask" : load("res://Resources/Components/Effects/Asks/General/AnyMon.tres") as SlotAsk,
 "must_be_ask": load("res://Resources/Components/Effects/Asks/General/AnyMon.tres") as SlotAsk,
 "card_type" : load("res://Resources/Components/Effects/Identifiers/AnyCard.tres") as Identifier}

#--------------------------------------
func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary] = []
	var signal_array_names: PackedStringArray = []
	var res_signal_list = ClassDB.class_get_signal_list("Resource")
	
	#Collect the name of every property that's in a poke_slot
	#Will not include any non-export variables
	for s in slot_instance.get_signal_list():
		if (not s in res_signal_list):
			signal_array_names.append(s.name)
	
	props.append({
		"name" : "from_ask",
		"type" : TYPE_OBJECT,
		"hint" : PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string" : "SlotAsk",
		"usage" : PROPERTY_USAGE_DEFAULT
	})
	#Append their names into an enum to select from
	props.append({
		"name" : "signal",
		"type" : TYPE_STRING,
		"hint" : PROPERTY_HINT_ENUM,
		"hint_string" : ",".join(signal_array_names),
		"usage" : PROPERTY_USAGE_DEFAULT
	})
	
	if _get("signal") == "attatch_en_signal" or _get("signal") == "discard_en_signal":
		props.append({
			"name" : "card_type",
			"type" : TYPE_OBJECT,
			"hint" : PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string" : "Identifier",
			"usage" : PROPERTY_USAGE_DEFAULT
		})
	
	if _get("signal") == "take_dmg" or _get("signal") == "used_power":
		props.append({
			"name" : "must_be_ask",
			"type" : TYPE_OBJECT,
			"hint" : PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string" : "SlotAsk",
			"usage" : PROPERTY_USAGE_DEFAULT
		})
	
	return props
#--------------------------------------

#--------------------------------------
#region GET FUNCTIONS
func _get(property):
	match property:
		"from_ask": return internal_data["from_ask"] as SlotAsk
		"signal": return internal_data["signal"]
		"must_be_ask": return internal_data["must_be_ask"] as SlotAsk
		"card_type": return internal_data["card_type"] as Identifier
	
	return null

func _property_can_revert(property: StringName):
	if (property == "from_ask" or property == "signal"
	or property == "must_be_ask" or property == "card_type"):
		return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	match property: 
		"signal": return "checked_up"
		"from_ask": return load("res://Resources/Components/Effects/Asks/General/AnyMon.tres") as SlotAsk
		"must_be_ask": return load("res://Resources/Components/Effects/Asks/General/AnyMon.tres") as SlotAsk
		"card_type": return load("res://Resources/Components/Effects/Identifiers/AnyCard.tres") as Identifier
	return null
#endregion
#--------------------------------------

#--------------------------------------
func _set(property, value):
	match property:
		"signal":
			internal_data["signal"] = value
			notify_property_list_changed()
			return true
		"from_ask": 
			if not value is SlotAsk:
				return false
			internal_data["from_ask"] = value as SlotAsk
			return true
		"must_be_ask":
			internal_data["must_be_ask"] = value
			return true
		"card_type":
			internal_data["card_type"] = value
			return true
	return false
#--------------------------------------

#--------------------------------------
#region SIGNAL FUNCTIONS
func connect_occurance():
	var slots: Array[PokeSlot] = Globals.full_ui.get_ask_slots(_get("from_ask"))
	
	for slot in slots:
		slot.connect(_get("signal"), should_occur)

func disconnect_occurance():
	var slots: Array[PokeSlot] = Globals.full_ui.get_ask_slots(_get("from_ask"))
	
	for slot in slots:
		slot.disconnect(_get("signal"), should_occur)

func single_connect(slot: PokeSlot):
	if _get("from_ask").check_ask(slot):
		slot.connect(_get("signal"), should_occur)

func single_disconnect(slot: PokeSlot):
	if _get("from_ask").check_ask(slot):
		slot.disconnect(_get("signal"), should_occur)

func should_occur(param: Variant = null):
	if param is PokeSlot:
		if _get("must_be_ask").check_ask(param):
			occur.emit()
			return
	elif param is Base_Card:
		if _get("card_type").identifier_bool(param):
			occur.emit()
			return
	else:
		occur.emit()
		return
#endregion
#--------------------------------------
