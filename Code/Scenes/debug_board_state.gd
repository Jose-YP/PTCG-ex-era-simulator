@icon("res://Art/ProjectSpecific/alpha.png")
extends Control
class_name BoardNode

@export var board_state: BoardState
@export var fundies: Fundies

@onready var full_ui: FullBoardUI = $FullUI

func _ready() -> void:
	full_ui.home_side = board_state.home_side
	set_up(true)
	set_up(false)

func set_up(home: bool):
	var temp_side: SideState = board_state.get_side(home)
	var ui: CardSideUI = full_ui.get_side(home)
	var player_type: Constants.PLAYER_TYPES = board_state.get_player_type(home)
	var home_slot_size: int = temp_side.bench_size + 2\
	 if board_state.doubles else temp_side.bench_size + 1 
	
	fundies.ui_slots = ui.get_slots()
	fundies.stack_manager.assign_deck(temp_side.deck)
	var deck = fundies.stack_manager.arrays.usable_deck
	#Set up pre defined slots
	for slot in temp_side.slots:
		slot.player_type = player_type
		ui.insert_slot(slot, temp_side.slots[slot])
		
		deck.remove_at(deck.find_custom(slot.current_card.same_card))
		if slot.tool_card:
			deck.remove_at(deck.find_custom(slot.tool_card.same_card))
		for card in slot.energy_cards:
			deck.remove_at(deck.find_custom(card.same_card))
		for card in slot.tm_cards:
			deck.remove_at(deck.find_custom(card.same_card))
		for card in slot.evolved_from:
			deck.remove_at(deck.find_custom(card.same_card))
	
	fundies.stack_manager.move_cards(temp_side.initial_hand,
		Constants.STACKS.DECK, Constants.STACKS.HAND)
	
	if temp_side.usable_deck.size() != 0:
		fundies.stack_manager.move_cards(fundies.stack_manager.arrays.usable_deck,
			Constants.STACKS.DECK, Constants.STACKS.DISCARD)
		fundies.stack_manager.move_cards(temp_side.usable_deck,
			Constants.STACKS.DISCARD, Constants.STACKS.DECK)
	
	var dict: Dictionary[Constants.STACKS, Array] = fundies.stack_manager.arrays.sendStackDictionary()
	full_ui.update_stacks(dict,player_type)

func _on_button_pressed() -> void:
	pass # Replace with function body.
