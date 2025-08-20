@tool
extends Control
class_name CardSideUI

##Not really a tool for functionality there's justa bug right now
##@tutorial https://github.com/godotengine/godot/commit/2d8f6c1b1d984222d1690f8afd504faed9f303be
##@tutorial https://stackoverflow.com/questions/79569605/my-godot-tool-script-produces-attempt-to-call-a-method-on-a-placeholder-instanc
@export var player_type: Consts.PLAYER_TYPES = Consts.PLAYER_TYPES.PLAYER
@export var home: bool = true

@onready var ui_slots: Array[Node] = %Active.get_children() + %Bench.get_children()
#$Main/Bench/BenchPokemon2, $Main/Bench/BenchPokemon3, $Main/Bench/BenchPokemon4, $Main/Bench/BenchPokemon5]
@onready var non_mon: NonMonUI = %Non_mon

func print_status():
	#------------------------------
	# [Active] [Supporter]
	# [Bench]
	#------------------------------
	const line: String = "---------------------------------------------"
	var status: String
	var active_mons: String
	var benched_mons: String
	var support: String
	var stack_status: String
	for slot in get_slots():
		var mon_name: String
		if slot.connected_slot.is_filled():
			mon_name = slot.connected_slot.current_card.name 
		if slot.active:
			active_mons = str(active_mons, " [", mon_name ,"]")
		else:
			benched_mons = str(benched_mons, " [", mon_name ,"]")
	
	stack_status = non_mon.print_stack_numbers()
	
	if non_mon.current_supporter:
		support = str("[",non_mon.current_supporter,"]")
	else: support = "SUPPORT: []"
	
	if home:
		status = str("HOME STATUS
		",line,"
		", stack_status,"
		", active_mons, "\t\t", support, "
		", benched_mons, "
		", line)
	else:
		status = str("AWAY STATUS
		",line,"
		", stack_status,"
		", benched_mons, "
		", support,"\t\t", active_mons,"
		", line)
	
	print(status)

func get_slots() -> Array[UI_Slot]:
	var arr: Array[UI_Slot]
	for slot in %Active.get_children():
		arr.append(slot as UI_Slot)
	for slot in %Bench.get_children():
		arr.append(slot as UI_Slot)
	return arr

func insert_slot(slot: PokeSlot, predefined: bool = false):
	if predefined or slot.is_active():
		for ui_slot in %Active.get_children():
			if not ui_slot.connected_slot.is_filled():
				ui_slot.attatch_pokeslot(slot, true)
				return
	else:
		for ui_slot in %Bench.get_children():
			if not ui_slot.connected_slot.is_filled():
				ui_slot.attatch_pokeslot(slot, true)
				return

func supporter_played() -> bool:
	return non_mon.current_supporter != null
