extends Node

var all_lists: Array[Dictionary]

func reformat(text: String) -> String:
	var result: String = text
	var icon_search = RegEx.new()
	var italics_search = RegEx.new()
	icon_search.compile(r"\{.*?\}")
	italics_search.compile(r"\(.*?\)")
	
	var matches = icon_search.search_all(text)
	var italics = italics_search.search_all(text)
	
	for found in matches:
		#Specific mentions of energy types should be replaced by icon
		var key: String = found.get_string(0).lstrip("{").rstrip("}")
		var index: int = Constants.energy_types.find(key)
		var icon_path: String = str("[img={20%}x{20%}]",
		Constants.energy_icons[index],"[/img]")
		
		if index == -1: push_error(key," isn't found in Constants energy_types")
		
		result = result.replace(found.get_string(0), icon_path)
	
	for found in italics:
		#Anything in parenthesis should be italisized
		var original: String = found.get_string(0)
		var wrapped: String = "[i]" + original + "[/i]"
		
		result = result.replace(original, wrapped)
	
	return result

func flags_to_type_array(type_flags: int) -> Array[String]:
	var types: Array[String] = []
	
	if type_flags & 1:
		types.append("Grass")
	if type_flags & 2:
		types.append("Fire")
	if type_flags & 4:
		types.append("Water")
	if type_flags & 8:
		types.append("Lightning")
	if type_flags & 16:
		types.append("Psychic")
	if type_flags & 32:
		types.append("Fighting")
	if type_flags & 64:
		types.append("Darkness")
	if type_flags & 128:
		types.append("Metal")
	if type_flags & 256:
		types.append("Colorless")
	
	return types

func get_allowed_flags(allowed: String = "All") -> int:
	match allowed:
		"Start":
			return (2 ** Constants.allowed_list_flags.find("Basic")
			 + 2 ** Constants.allowed_list_flags.rfind("Fossil"))
		"All":
			return 2 ** Constants.allowed_list_flags.size() - 1
		_:
			return 2 ** Constants.allowed_list_flags.find(allowed)

func get_card_flags(card: Base_Card) -> int:
	var card_flags: int = 0
	
	if card.categories & 1:
		
		if card.pokemon_properties.evo_stage == "Basic":
			card_flags += Conversions.get_allowed_flags("Basic")
		elif card.fossil: 
			card_flags += Conversions.get_allowed_flags("Fossil")
		else:
			card_flags += Conversions.get_allowed_flags("Evolution")
		
	elif card.categories & 2:
		var considered = card.trainer_properties.considered
		if considered == "Rocket's Secret Machine": considered = "RSM"
		if considered == "Supporter": considered = "Support"
		card_flags += Conversions.get_allowed_flags(considered)
	
	if card.categories & 4:
		card_flags += Conversions.get_allowed_flags("Energy")
	
	return card_flags

#For use in lists
func default_card_sort(button1: Button, button2: Button):
	var card1: Base_Card = button1.card
	var card2: Base_Card = button2.card
	#First prioritize allowed cards
	var first_bool: bool = false
	var second_bool: bool = false
	
	for list in all_lists:
		first_bool = list[card1] or first_bool
		second_bool = list[card2] or second_bool
	if first_bool and not second_bool:
		return true
	elif second_bool and not first_bool:
		return false
	
	#If they're both (not) allowed check card priority
	else:
		return card1.card_priority(card2)

func stack_into_string(stack: Constants.STACKS):
	match stack:
		Constants.STACKS.HAND:
			return "Hand"
		Constants.STACKS.DISCARD:
			return "Discard"
		Constants.STACKS.DECK:
			return "Deck"
		Constants.STACKS.PRIZE:
			return "Prize"
		Constants.STACKS.LOST:
			return "Lost Zone"
		Constants.STACKS.PLAY:
			return "In Play"
		_:
			printerr(stack, "Isn't recognized as a viable type")
