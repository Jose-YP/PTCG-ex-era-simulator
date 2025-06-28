extends Resource
class_name OverRide

@export var can_evolve_into: String

signal finished

func play_effect():
	print("PLAY OVERIDE")
	
	finished.emit()
