@icon("res://Art/ProjectSpecific/leaves.png")
extends Resource
class_name Alleviate

@export var ask: SlotAsk = preload("res://Resources/Components/Effects/Asks/General/FromSource.tres")

@export var remove_conditions: bool = false
@export var remove_shockwave: bool = false
@export var remove_imprison: bool = false

signal finished

func play_effect(reversable: bool = false):
	print("PLAY ALLEVIATE")
	
	for slot in Globals.full_ui.get_ask_slots(ask):
		if remove_conditions:
			slot.alleviate_all()
		if remove_shockwave:
			slot.applied_condition.shockwave = false
		if remove_imprison:
			slot.applied_condition.imprision = false
	
	finished.emit()
