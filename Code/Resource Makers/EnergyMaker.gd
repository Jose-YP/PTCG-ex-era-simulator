extends Resource
class_name Energy

@export_group("Properties")
@export_enum("Basic Energy", "Special Energy") var considered: String = "Special Energy"

@export_group("Prerequisites")
@export var asks: Ask
@export var fail_provide: bool = false ##Should failure constitute providing different kinds of energy?
@export var fail_effect: EffectCall ##What should happen if the ask isn't met
@export var success_effect: EffectCall ##What should happen if the ask is met
@export var always_effect: EffectCall ##What should happen no matter what?

@export_group("Duration")
@export var turns: int = -1 ##-1 means forever, otherwise it's how many turns it'll last

@export_group("Provides")
@export var number: int = 1
@export var react: bool = false
@export_enum("None","FF","GL","WP") var holon_type: String = "None"
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var type: int = 1
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var fail_type: int = 1

func how_display(passed: bool = true) -> String:
	#Figure out how the energy will be displayed
	var using: int = 0
	if passed: using = type
	else: passed = fail_type
	
	if react: return "React"
	if holon_type != "None": return holon_type
	if using == 2 ** 9 - 1: return "Rainbow"
	elif using == 2 ** 7 + 2 ** 6: return "Dark Metal"
	elif using == 2 ** 5 + 2 ** 6: return "Magma"
	elif using == 2 ** 2 + 2 ** 6: return  "Aqua"
	
	var index = int((log(float(using)) / log(2)))
	return Constants.energy_types[index]
