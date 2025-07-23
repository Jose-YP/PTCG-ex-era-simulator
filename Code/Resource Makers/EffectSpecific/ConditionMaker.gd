@icon("res://Art/ProjectSpecific/poison.png")
extends Resource
class_name Condition

@export_group("Conditions")
##imprision/shockwave will ignore this
@export var side: Consts.SIDES = Consts.SIDES.DEFENDING
@export var slot: Consts.SLOTS = Consts.SLOTS.TARGET

@export var choose_condition: bool = false
@export_enum("None", "Normal", "Heavy") var poison: int = 0
@export_enum("None", "Normal", "Heavy") var burn: int = 0
@export_enum("None","Asleep",
"Paralyze", "Confused") var mutually_exclusive_conditions: int = 0
@export var imprision: bool = false
@export var shockwave: bool = false
@export var knockOut: bool = false

signal finished

func play_effect(reversable: bool = false):
	print("PLAYING CONDITION")
	if choose_condition:
		print()
	else:
		var slots: Array[PokeSlot] = Globals.fundies.get_poke_slots(side, slot)
	
		for filtered in slots:
			filtered.add_condition(self)
	
	finished.emit()
