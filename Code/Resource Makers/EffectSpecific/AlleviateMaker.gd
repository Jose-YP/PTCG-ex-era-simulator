extends Resource
class_name Alleviate

@export var side: Constants.SIDES = Constants.SIDES.PLAYER
@export var slot: Constants.SLOTS = Constants.SLOTS.ATTACKER

@export var remove_conditions: bool = false
@export var remove_shockwave: bool = false
@export var remove_imprison: bool = false

func play_effect(fundies: Fundies):
	print("PLAY ALLEVIATE")
