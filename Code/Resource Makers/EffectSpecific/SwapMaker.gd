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

func play_effect(fundies: Fundies, attacking_targets: Array[PokeSlot], defender_targets: Array[PokeSlot]):
	print("PLAY SWAP")
