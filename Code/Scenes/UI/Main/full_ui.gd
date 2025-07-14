extends Control
class_name FullBoardUI

@export var singles: bool = true

var current_card: Control

@onready var player_side: CardSideUI = $PlayerSide
@onready var opponent_side: CardSideUI = $OpponentSide
@onready var stadium: Button = %ArtButton

var home_side: Consts.PLAYER_TYPES

func _ready() -> void:
	%ArtButton.get_child(0).size = %ArtButton.size
	%ArtButton.current_card = null

func get_side(home: bool) -> CardSideUI:
	return player_side if home else opponent_side

func all_slots() -> Array[UI_Slot]:
	return player_side.get_slots() + opponent_side.get_slots()

func get_slots(side: Consts.SIDES, slot: Consts.SLOTS) -> Array[UI_Slot]:
	return all_slots().filter(func(uislot: UI_Slot):
		return uislot.connected_slot.is_in_slot(side, slot))

func get_poke_slots(side: Consts.SIDES,
 slot: Consts.SLOTS = Consts.SLOTS.ALL) -> Array[PokeSlot]:
	var poke: Array[PokeSlot]
	for ui_slot in all_slots():
		if ui_slot.connected_slot.is_in_slot(side, slot):
			poke.append(ui_slot.connected_slot)
	
	return poke

func remove_card() -> void:
	print("IHJBEFDI")

func update_stacks(dict: Dictionary[Consts.STACKS,Array],
 side: Consts.PLAYER_TYPES):
	var temp_side: CardSideUI = get_side(home_side == side)
	for stack in dict:
		if stack == Consts.STACKS.PLAY: break
		temp_side.non_mon.update_stack(stack, dict[stack].size())

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("A") and Globals.checking:
		remove_card()
