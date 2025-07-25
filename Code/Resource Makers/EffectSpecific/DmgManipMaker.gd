@icon("res://Art/ProjectSpecific/steroids.png")
extends Resource
class_name DamageManip

@export_enum("Add", "Remove", "Swap") var mode
##Add Counters if this is false
@export var remove: bool = true
##-1 means remove/add max ammount
@export_range(-1,20) var how_many: int = 1
##If this not -1, the player must choose between the choices for how_many times.
@export_range(-1,5) var choose_num: int = -1
##Who will get the counter manipulation
@export var ask: SlotAsk = preload("res://Resources/Components/Effects/Asks/General/Self.tres")
##Determines how many will be added/removed based on the Counter
@export_group("Counter")
@export var plus: bool = false
@export var comparator: Comparator

signal finished

func play_effect(reversable: bool = false):
	print("PLAY DAMAGE MANIPULATION")
	var counters: int = how_many 
	if comparator:
		if plus:
			counters += comparator.start_comparision()
		else:
			counters -= comparator.start_comparision()
	counters *= -1 if remove else 1
	
	#Choose from candidates shown by ask
	if choose_num != -1:
		for i in range(choose_num):
			var manip_candidate: PokeSlot
			manip_candidate = await Globals.fundies.card_player.get_choice_candidates(\
			"Choose which pokemon to ", func(slot): return ask.check_ask(slot), reversable)
			
			if manip_candidate == null: return
			
			manip_candidate.dmg_manip(counters)
	
	#Apply manip on all ask candidates
	else:
		for slot in Globals.full_ui.get_ask_slots(ask):
			slot.dmg_manip(counters)
	
	finished.emit()
