extends Resource
class_name Draw

@export var side: Constants.SIDES = Constants.SIDES.ATTACKING
@export var counter: Counter

func play_effect(fundies: Fundies):
	print("PLAY DRAW")
