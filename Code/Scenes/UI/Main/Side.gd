@tool
extends Control
class_name CardSideUI

##Not really a tool for functionality there's justa bug right now
##@tutorial https://github.com/godotengine/godot/commit/2d8f6c1b1d984222d1690f8afd504faed9f303be
##@tutorial https://stackoverflow.com/questions/79569605/my-godot-tool-script-produces-attempt-to-call-a-method-on-a-placeholder-instanc

@onready var ui_slots: Array[UI_Slot] = [%ActivePokemon, $Main/Bench/BenchPokemon, 
$Main/Bench/BenchPokemon2, $Main/Bench/BenchPokemon3, $Main/Bench/BenchPokemon4, $Main/Bench/BenchPokemon5]
@onready var non_mon: NonMonUI = $Non_mon

func get_slots() -> Array[UI_Slot]:
	return [%ActivePokemon, $Main/Bench/BenchPokemon, 
$Main/Bench/BenchPokemon2, $Main/Bench/BenchPokemon3, $Main/Bench/BenchPokemon4, $Main/Bench/BenchPokemon5]

func insert_active_slot(slot):
	for ui_slot in $Main/Active.get_children():
		if not ui_slot.connected_slot:
			ui_slot.connected_slot = slot

func insert_bench_slot(slot):
	for ui_slot in $Main/Bench.get_children():
		if not ui_slot.connected_slot:
			ui_slot.connected_slot = slot
