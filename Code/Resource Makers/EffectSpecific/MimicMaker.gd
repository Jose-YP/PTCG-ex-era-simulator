@icon("res://Art/ProjectSpecific/man.png")
extends Resource
class_name Mimic

##Target for mimicry
@export var side: Constants.SIDES = Constants.SIDES.BOTH
@export var slots: Constants.SLOTS = Constants.SLOTS.ALL
##Take attacks from stated pokemon + any cards they evolved
@export var attatched_cards: bool = false
##You can only use the attack if you meet the energy requirements
@export var must_pay_energy: bool = false
@export var adjustable_type: bool = false

signal finished

func play_effect(reversable: bool = false):
	print("PLAY MIMIC")
	
	finished.emit()
