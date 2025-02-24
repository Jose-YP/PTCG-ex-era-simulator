extends Node

func insert_icons(text: String) -> String:
	var result: String = text
	var regex = RegEx.new()
	regex.compile(r"\{.*?\}")
	
	var matches = regex.search_all(text)
	for found in matches:
		var key: String = found.get_string(0).lstrip("{").rstrip("}")
		var index: int = Constants.energy_types.find(key)
		var icon_path: String = str("[img={20%}x{20%}]",
		Constants.energy_icons[index],"[/img]")
		
		result = result.replace(found.get_string(0), icon_path)
	
	return result
