extends Control
class_name FullBoardUI

var current_card: Control

@onready var player_side: CardSideUI = $PlayerSide
@onready var opponent_side: CardSideUI = $OpponentSide
@onready var stadium: Button = %ArtButton
var home_side: Constants.PLAYER_TYPES

func _ready() -> void:
	%ArtButton.get_child(0).size = %ArtButton.size
	#%ArtButton.art = null

func get_side(home: bool) -> CardSideUI:
	return player_side if home else opponent_side

func remove_card() -> void:
	print("IHJBEFDI")

func update_stacks(dict: Dictionary[Constants.STACKS,Array],
 side: Constants.PLAYER_TYPES):
	var temp_side: CardSideUI = get_side(home_side == side)
	for stack in dict:
		temp_side.non_mon.update_stack(stack, dict[stack].size())

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("A") and Globals.checking:
		remove_card()
