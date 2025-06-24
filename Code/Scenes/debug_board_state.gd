@icon("res://Art/ProjectSpecific/alpha.png")
extends Control
class_name BoardNode

@export var board_state: BoardState
@export var home_side: CardSideUI
@export var away_side: CardSideUI
@export var fundies: Fundies

func _ready() -> void:
	var home_slot_size: int = board_state.home.bench_size + 2\
	 if board_state.doubles else board_state.home.bench_size + 1 
	fundies.ui_slots = home_side.get_slots()
	#Set up pre defined slots
	for slot in board_state.home.slots:
		home_side.insert_slot(slot, board_state.home.slots[slot])
	
	%ArtButton.get_child(0).size = %ArtButton.size
	fundies.stack_manager.assign_deck(board_state.home.deck)
	

func set_up(home: bool):
	var temp_side: SideState = board_state.get_side(home)
	var ui: CardSideUI = home_side if home else away_side
	
	var home_slot_size: int = board_state.home.bench_size + 2\
	 if board_state.doubles else board_state.home.bench_size + 1 
	fundies.ui_slots = home_side.get_slots()
	#Set up pre defined slots
	for slot in board_state.home.slots:
		home_side.insert_slot(slot, board_state.home.slots[slot])
