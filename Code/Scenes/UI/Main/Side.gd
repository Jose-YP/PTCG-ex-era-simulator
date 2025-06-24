@tool
extends Control
class_name CardSideUI

##Not really a tool for functionality there's justa bug right now
##@tutorial https://github.com/godotengine/godot/commit/2d8f6c1b1d984222d1690f8afd504faed9f303be
##@tutorial https://stackoverflow.com/questions/79569605/my-godot-tool-script-produces-attempt-to-call-a-method-on-a-placeholder-instanc

@onready var ui_slots: Array[Node] = %Active.get_children() + %Bench.get_children()
#$Main/Bench/BenchPokemon2, $Main/Bench/BenchPokemon3, $Main/Bench/BenchPokemon4, $Main/Bench/BenchPokemon5]
@onready var non_mon: NonMonUI = $Non_mon

func get_slots() -> Array[UI_Slot]:
	var arr: Array[UI_Slot]
	for slot in %Active.get_children():
		arr.append(slot)
	for slot in %Bench.get_children():
		arr.append(slot)
	return arr

func insert_slot(slot: PokeSlot, predefined: bool):
	if slot.is_active() or predefined:
		for ui_slot in %Active.get_children():
			if not ui_slot.connected_slot:
				ui_slot.connected_slot = slot
	else:
		for ui_slot in %Bench.get_children():
			if not ui_slot.connected_slot:
				ui_slot.connected_slot = slot
