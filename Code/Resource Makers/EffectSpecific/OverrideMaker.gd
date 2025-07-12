extends Resource
##This is just a schmorgesborg of stuff I had no place for otherwise
class_name OverRide

@export var rare_candy: bool = false
@export var can_evolve_into: String
@export_flags("Grass","Fire","Water",
"Lightning","Psychic","Fighting",
"Darkness","Metal","Colorless") var new_type: int = 0

signal finished

func play_effect(reversable: bool = false):
	print("PLAY OVERIDE")
	
	finished.emit()
