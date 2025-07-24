@icon("res://Art/ProjectSpecific/alpha.png")
extends Control
class_name BoardNode

#For easy access: PokeSlot
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
	Globals.board_state = board_state
	set_up(true)
	set_up(false)
	
	fundies.current_turn_print()

func set_up(home: bool):
	var temp_side: SideState = board_state.get_side(home).duplicate()
	var ui: CardSideUI = full_ui.get_side(home)
	var player_type: Consts.PLAYER_TYPES = board_state.get_player_type(home)
	var stacks: CardStacks = temp_side.card_stacks.duplicate()
	
	Globals.board_state = board_state
	
	ui.player_type = player_type
	if player_type == Consts.PLAYER_TYPES.CPU:
		var adding_cpu = Consts.cpu_scene.instantiate()
		adding_cpu.home_side = home
		fundies.cpu_players.append(adding_cpu)
		fundies.add_child(adding_cpu)
	
	fundies.stack_manager.assign_card_stacks(stacks, home)
	stacks.make_deck()
	
	#Set up pre defined slots
	for slot in temp_side.slots:
		var new_arr: Array[Base_Card] = []
		var new_slot: PokeSlot = slot.duplicate()
		
		#I don't know if this works, the duplicated resources don't seem to last
		for en in new_slot.energy_cards:
			var duplicated: Base_Card = en.duplicate()
			new_slot.register_energy_timer(duplicated)
			new_arr.append(duplicated)
		new_slot.energy_cards = new_arr
		ui.insert_slot(new_slot, temp_side.slots[slot])
		stacks.account_for_slot(new_slot)
	
	stacks.setup()
	full_ui.update_stacks(stacks.sendStackDictionary(),player_type)

func _input(event: InputEvent) -> void:
	if event.is_action("TEST") and not test_out and test:
		fundies.record_source_target(true, 
		 [full_ui.get_poke_slots(Consts.SIDES.ATTACKING, Consts.SLOTS.ACTIVE)[0]],
		 [])
		var new = test.instantiate()
		
		#region EDIT WITH WHATEVER
		new.side = full_ui.get_side(true)
		new.singles = false
		#endregion
		
		add_child(new)
		test_out = true
