@icon("res://Art/Counters/Spiral.png")
extends Resource
class_name DamageManip

##If this is not -1, put this effect in a stack that applies later, in the mean time get it's srctrgt
@export var turn_delay: int = -1
@export var prevent_KO: bool = false
@export_enum("Add", "Remove", "Swap") var mode: String = "Remove"
##-1 means remove/add max ammount
@export_range(-1,20) var how_many: int = 1
@export var choosing: Consts.SIDES = Consts.SIDES.SOURCE
##If this is true, then the player can divide [member how_many]
## in any way instead of adding it [member choose_num] times
@export var anyway_u_like: bool = false
##The player must choose to add [member how_many] this many times.
##[br] On -1, ignore and place [member how_many] on every mon that meets [member ask]
@export var choose_num: int = 1
##Who will get the counter manipulation[br]
##On [enum Swap] this determines who gives dmg counters
@export var ask: SlotAsk = preload("res://Resources/Components/Effects/Asks/General/Self.tres")
##For DF9 Dragonite ex who uses a second type of DmgManip using leftovers
@export var with_leftover: DamageManip
##Determines how many will be added/removed based on the Counter
@export_group("Counter")
@export var vary_choose_num: bool = false
##If this is false, subtract based on comparator instead
@export var plus: bool = true
@export var comparator: Comparator
@export var modifier: int = 1
@export_group("Swap Exclusive")
@export var takers: SlotAsk

signal finished

func play_effect(reversable: bool = false, replace_num: int = -1) -> void:
	print("PLAY DAMAGE MANIPULATION")
	if anyway_u_like:
		await dmg_manip_box(reversable, replace_num)
	elif mode != "Swap":
		await simple_manip(reversable, replace_num)
	else:
		await swap_manip(reversable, replace_num)
	
	finished.emit()

func simple_manip(reversable: bool = false, replace_num: int = -1):
	print("simple this time")
	var counters: int = how_many if replace_num == -1 else replace_num
	var mod_by: int
	
	if comparator:
		mod_by = await comparator.start_comparision() * modifier
		mod_by *= 1 if plus else -1
		if comparator.has_coinflip():
			await SignalBus.finished_coinflip
		
	
	if vary_choose_num:
		choose_num += mod_by
	else:
		counters += mod_by
	counters *= -10 if mode == "Remove" else 10
	
	#Choose from candidates shown by ask
	if choose_num != -1:
		for i in range(choose_num):
			var manip_candidate: PokeSlot
			manip_candidate = await Globals.fundies.card_player.get_choice_candidates(\
			"Choose which pokemon to ", func(slot): return ask.check_ask(slot), reversable)
			
			if manip_candidate == null: return
			
			manip_candidate.dmg_manip(counters, turn_delay)
	
	#Apply manip on all ask candidates
	else:
		for slot in Globals.full_ui.get_ask_slots(ask):
			slot.dmg_manip(counters, turn_delay)
	 
	finished.emit()

func dmg_manip_box(reversable: bool = false, replace_num: int = -1):
	var dmg_manip: DmgManipBox = Consts.dmg_manip_box.instantiate()
	var counters: int = how_many if replace_num == -1 else replace_num
	
	if comparator:
		if plus:
			counters += comparator.start_comparision() * modifier
		else:
			counters -= comparator.start_comparision() * modifier
	
	dmg_manip.max_counters = counters
	dmg_manip.first_ask = ask
	dmg_manip.second_ask = takers
	dmg_manip.mode = mode
	
	Globals.fundies.add_child(dmg_manip)
	
	await dmg_manip.finished
	print("Done")

func swap_manip(reversable: bool = false, replace_num: int = -1):
	pass
