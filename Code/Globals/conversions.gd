extends Node

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
