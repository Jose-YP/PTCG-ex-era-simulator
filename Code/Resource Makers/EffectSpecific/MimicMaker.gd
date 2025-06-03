extends Resource
class_name Mimic

##Target for mimicry
@export var side: Constants.SIDES = Constants.SIDES.BOTH
@export var slots: Constants.SLOTS = Constants.SLOTS.ALL
##mimicry might be it's own resource
@export_enum("No","AttatchedLimited", "Attatched",
 "AnyLimited", "Any") var mimic: int = 0

func play_effect(fundies: Fundies):
	print("PLAY MIMIC")
