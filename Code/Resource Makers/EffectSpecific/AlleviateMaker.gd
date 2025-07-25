@icon("res://Art/ProjectSpecific/leaves.png")
extends Resource
class_name Alleviate

@export var ask: SlotAsk
@export var side: Consts.SIDES = Consts.SIDES.ATTACKING
@export var slot: Consts.SLOTS = Consts.SLOTS.TARGET

@export var remove_conditions: bool = false
@export var remove_shockwave: bool = false
@export var remove_imprison: bool = false

signal finished

func play_effect(reversable: bool = false):
	print("PLAY ALLEVIATE")
	var slots: Array[PokeSlot] = Globals.full_ui.get_poke_slots()
		
	
	finished.emit()
