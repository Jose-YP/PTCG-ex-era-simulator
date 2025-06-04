extends Resource
class_name PokeSwap

##Does the target choose which active mon to switch out?
##If not it's the defender
@export var choose_active: bool = false
##Who switches according to who
@export var chosing: Constants.SIDES = Constants.SIDES.DEFENDING
##Which side are they switching
@export var affected: Constants.SIDES = Constants.SIDES.DEFENDING
##What are thier options on this side
@export var slots: Constants.SLOTS = Constants.SLOTS.ALL
@export_subgroup("Mimic")
##mimicry might be it's own resource
@export_enum("No","AttatchedLimited", "Attatched",
 "AnyLimited", "Any") var mimic: int = 0

func play_effect(fundies: Fundies):
	print("PLAY SWAP")
