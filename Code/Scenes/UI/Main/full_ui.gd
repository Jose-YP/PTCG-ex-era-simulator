extends Control
class_name FullBoardUI

@export var singles: bool = true

var current_card: Control

@onready var end_turn: Button = $EndTurn
@onready var player_side: CardSideUI = $PlayerSide
@onready var opponent_side: CardSideUI = $OpponentSide
@onready var stadium: Button = %ArtButton

var home_side: Consts.PLAYER_TYPES

#region INITALIZATION & PROCESSING
func _ready() -> void:
	%ArtButton.get_child(0).size = %ArtButton.size
	%ArtButton.current_card = null
	Globals.full_ui = self

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("A") and Globals.checking:
		remove_card()
#endregion

#region HELPERS
func get_home_side(home: bool) -> CardSideUI:
	return player_side if home else opponent_side

func get_const_side(side: Consts.SIDES) -> CardSideUI:
	match side:
		Consts.SIDES.SOURCE:
			return get_home_side(true)
		Consts.SIDES.OTHER:
			return get_home_side(false)
		_:
			return get_home_side(Globals.fundies.get_considered_home(side))

func all_slots() -> Array[UI_Slot]:
	return player_side.get_slots() + opponent_side.get_slots()

func get_slots(side: Consts.SIDES, slot: Consts.SLOTS) -> Array[UI_Slot]:
	return all_slots().filter(func(uislot: UI_Slot):
		return uislot.connected_slot.is_in_slot(side, slot))

func get_poke_slots(side: Consts.SIDES,
 slot: Consts.SLOTS = Consts.SLOTS.ALL) -> Array[PokeSlot]:
	var pokeslots: Array[PokeSlot]
	for ui_slot in all_slots():
		if ui_slot.connected_slot.is_in_slot(side, slot):
			pokeslots.append(ui_slot.connected_slot)
	
	return pokeslots

func get_ask_slots(ask: SlotAsk) -> Array[PokeSlot]:
	var pokeslots: Array[PokeSlot]
	for ui_slot in all_slots():
		if ask.check_ask(ui_slot.connected_slot):
			pokeslots.append(ui_slot.connected_slot)
	return pokeslots

func get_occurance_slots() -> Array[PokeSlot]:
	var pokeslots: Array[PokeSlot]
	for ui_slot in all_slots():
		if ui_slot.connected_slot.is_filled() and ui_slot.connected_slot.has_occurance():
			pokeslots.append(ui_slot.connected_slot)
	return pokeslots

#endregion

func remove_card() -> void:
	print("IHJBEFDI")

func update_stacks(dict: Dictionary[Consts.STACKS,Array],
 side: Consts.PLAYER_TYPES):
	var temp_side: CardSideUI = get_home_side(home_side == side)
	for stack in dict:
		if stack == Consts.STACKS.PLAY: break
		temp_side.non_mon.update_stack(stack, dict[stack].size())

func set_between_turns():
	player_side.non_mon.sync_stacks()
	opponent_side.non_mon.sync_stacks()
	end_turn.disabled = not Globals.fundies.is_home_side_player()
	
	for slot in all_slots():
		await slot.connected_slot.pokemon_checkup()
