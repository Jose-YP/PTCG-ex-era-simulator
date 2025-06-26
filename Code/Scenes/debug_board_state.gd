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
	var stacks: CardStacks = temp_side.card_stacks
	
	fundies.ui_slots = ui.get_slots()
	fundies.stack_manager.assign_card_stacks(stacks, home)
	stacks.setup()
	
	#Set up pre defined slots
	for slot in temp_side.slots:
		slot.player_type = player_type
		ui.insert_slot(slot, temp_side.slots[slot])
		stacks.account_for_slot(slot)
	
	full_ui.update_stacks(stacks.sendStackDictionary(),player_type)

func _on_button_pressed() -> void:
	pass # Replace with function body.
