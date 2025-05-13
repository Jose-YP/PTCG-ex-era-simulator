extends Control
class_name CardSideUI

@onready var ui_slots: Array[UI_Slot] = [%ActivePokemon, $Main/Bench/BenchPokemon, 
$Main/Bench/BenchPokemon2, $Main/Bench/BenchPokemon3, $Main/Bench/BenchPokemon4, $Main/Bench/BenchPokemon5]
@onready var non_mon: NonMonUI = $Non_mon
