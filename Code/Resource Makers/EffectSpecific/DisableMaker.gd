extends Resource
class_name Disable

#@export_group("Disable")
@export var side: Constants.SIDES = Constants.SIDES.OPP
@export var slot: Constants.SLOTS = Constants.SLOTS.ALL
@export var duration: int = -1
@export var no_weakness: bool = false
@export var no_resistance: bool = false
@export var instead_of_damage: bool = false
@export var do_nothing: bool = false
@export_enum("Can", "Flip", "Can't") var attack: int = 0
@export_enum("Can", "Flip", "Can't") var power: int = 0
@export_subgroup("Retreat")
##-1 means forever, otherwise it's turn duration
@export var retreat_duration: int = 1
@export var disable_retreat: bool = false

func play_effect(fundies: Fundies):
	print("PLAY DISABLE")
