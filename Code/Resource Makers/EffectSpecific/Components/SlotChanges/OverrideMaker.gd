extends SlotChange
##This is just a schmorgesborg of stuff I had no place for otherwise
class_name OverRide

@export var rare_candy: bool = false
@export var can_evolve_into: String

func how_display() -> Dictionary[String, bool]:
	return {"OverRide" : true}
