@icon("res://Art/ProjectSpecific/alpha.png")
extends Control
class_name BoardNode

@export_enum("None", "Fail", "Success", "All") var debug_prompt: int = 0
@export var board_state: BoardState
@export var fundies: Fundies
@export var doubles: bool = true
@export var test: PackedScene

var full_ui: FullBoardUI
var singles_ui: PackedScene = load("res://Scenes/UI/UICollections/full_ui.tscn")
var doubles_ui: PackedScene = load("res://Scenes/UI/UICollections/full_ui_doubles.tscn")
var test_out: bool = false

func _ready() -> void:
	full_ui = doubles_ui.instantiate() if doubles else singles_ui.instantiate()
	add_child(full_ui)
	full_ui.home_side = board_state.home_side
	set_up(true)
	set_up(false)
	
	Globals.fundies = fundies
	Globals.full_ui = full_ui
	fundies.current_turn_print()

func set_up(home: bool):
	var temp_side: SideState = board_state.get_side(home).duplicate()
	var ui: CardSideUI = full_ui.get_side(home)
	var player_type: Constants.PLAYER_TYPES = board_state.get_player_type(home)
	var stacks: CardStacks = temp_side.card_stacks.duplicate()
	
	ui.player_type = player_type
	fundies.stack_manager.assign_card_stacks(stacks, home)
	stacks.make_deck()
	
	#Set up pre defined slots
	for slot in temp_side.slots:
		var new_arr: Array[Base_Card]
		var new_slot: PokeSlot = slot.duplicate()
		for en in slot.energy_cards:
			new_arr.append(en.duplicate())
		slot.energy_cards = new_arr
		ui.insert_slot(new_slot, temp_side.slots[slot])
		stacks.account_for_slot(new_slot)
	
	stacks.setup()
	full_ui.update_stacks(stacks.sendStackDictionary(),player_type)

func _on_button_pressed() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action("TEST") and not test_out and test:
		fundies.record_source_target(true, 
		 [full_ui.get_poke_slots(Constants.SIDES.ATTACKING, Constants.SLOTS.ACTIVE)[0]],
		 [])
		var new = test.instantiate()
		
		#region EDIT WITH WHATEVER
		new.side = full_ui.get_side(true)
		new.singles = false
		#endregion
		
		add_child(new)
		test_out = true
