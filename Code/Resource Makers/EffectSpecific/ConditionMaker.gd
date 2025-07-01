@icon("res://Art/ProjectSpecific/poison.png")
extends Resource
class_name Condition

@export_group("Conditions")
##imprision/shockwave will ignore this
@export var side: Constants.SIDES = Constants.SIDES.DEFENDING
@export var slot: Constants.SLOTS = Constants.SLOTS.TARGET

@export var choose_condition: bool = false
@export_enum("None", "Normal", "Heavy") var poison: int = 0
@export_enum("None", "Normal", "Heavy") var burn: int = 0
@export_flags("Imprision", "Shockwave") var addable_effects: int = 0
@export_enum("None","Asleep",
"Paralyze", "Confused") var mutually_exclusive_conditions: int = 0
@export var knockOut: bool = false

signal finished

func play_effect():
	print("PLAYING CONDITION")
	
	finished.emit()
