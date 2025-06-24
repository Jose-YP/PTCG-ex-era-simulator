@icon("res://Art/ProjectSpecific/alpha.png")
extends Control
class_name BoardNode

@export var board_state: BoardState
@export var player_side: CardSideUI
@export var opponent_side: CardSideUI
@export var fundies: Fundies

func _ready() -> void:
	var home_slot_size: int = board_state.home_bench_size + 2\
	 if board_state.doubles else board_state.home_bench_size + 1 
	#Set up pre defined slots
	for slot in board_state.home_slots:
		player_side.insert_slot(slot, board_state.home_slots[slot])
	
	fundies.ui_slots = player_side.get_slots()
	fundies.player_resources.assign_deck(board_state.home_deck)
