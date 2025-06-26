extends HBoxContainer
class_name NonMonUI

@export var player: bool = true

@onready var stacks: Dictionary[Constants.STACKS, StackButton] = {Constants.STACKS.DISCARD:%DiscardButton,
Constants.STACKS.PRIZE:%PrizeButton, Constants.STACKS.DECK:%DeckButton, Constants.STACKS.HAND:%HandButton}

var current_supporter: Base_Card

func _ready() -> void:
	for button in stacks:
		stacks[button].player = player
	if not player:
		$Stacks.move_to_front()
	%ArtButton.get_child(0).size = %ArtButton.size
	clear_supporter()

func update_stack(which: Constants.STACKS, num: int):
	stacks[which].update(num)

func show_supporter(card: Base_Card):
	%ArtButton.current_card = card
	current_supporter = card

func clear_supporter():
	%ArtButton.current_card = null
	current_supporter = null
