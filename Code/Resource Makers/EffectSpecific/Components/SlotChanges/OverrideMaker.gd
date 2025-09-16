extends SlotChange
##This is just a schmorgesborg of stuff I had no place for otherwise
class_name OverRide

@export var rare_candy: bool = false
@export var can_evolve_into: String


func play_effect(reversable: bool = false, replace_num: int = -1) -> void:
	print("PLAY OVERIDE")
	
	finished.emit()
