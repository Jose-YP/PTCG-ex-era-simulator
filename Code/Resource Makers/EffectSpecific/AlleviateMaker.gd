extends Resource
class_name Alleviate

@export var side: Constants.SIDES = Constants.SIDES.ATTACKING
@export var slot: Constants.SLOTS = Constants.SLOTS.TARGET

@export var remove_conditions: bool = false
@export var remove_shockwave: bool = false
@export var remove_imprison: bool = false

func play_effect(fundies: Fundies, attacking_targets: Array[PokeSlot], defender_targets: Array[PokeSlot]):
	print("PLAY ALLEVIATE")
