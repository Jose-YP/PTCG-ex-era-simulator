@icon("res://Art/ProjectSpecific/leaves.png")
extends Resource
class_name Alleviate

@export var side: Constants.SIDES = Constants.SIDES.ATTACKING
@export var slot: Constants.SLOTS = Constants.SLOTS.TARGET

@export var remove_conditions: bool = false
@export var remove_shockwave: bool = false
@export var remove_imprison: bool = false

signal finished

func play_effect():
	print("PLAY ALLEVIATE")
	finished.emit()
