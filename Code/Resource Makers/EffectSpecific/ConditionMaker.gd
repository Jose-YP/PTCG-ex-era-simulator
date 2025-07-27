@icon("res://Art/Counters/Poison.png")
extends Resource
class_name Condition

@export var ask: SlotAsk = preload("res://Resources/Components/Effects/Asks/General/Other.tres")

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

func play_effect(reversable: bool = false, replace_num: int = -1) -> void:
	print("PLAYING CONDITION")
	if choose_condition:
		print()
	else:
		var slots: Array[PokeSlot] = Globals.full_ui.get_ask_slots(ask)
		
		for filtered in slots:
			filtered.add_condition(self)
	
	finished.emit()
