@icon("res://Art/ProjectSpecific/poison.png")
extends Resource
class_name Condition

##imprision/shockwave will ignore this
@export var side: Consts.SIDES = Consts.SIDES.DEFENDING
@export var slot: Consts.SLOTS = Consts.SLOTS.TARGET

@export var choose_condition: bool = false
##Number of dmg Counters added from this effect, multiplied by 10 on implementation
@export_range(0,20,1) var poison: int = 0
##Number of dmg Counters added from this effect, multiplied by 10 on implementation
@export_range(0,20,1) var burn: int = 0
@export var turn_cond: Consts.TURN_COND = Consts.TURN_COND.NONE
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
