extends HBoxContainer
class_name NonMonUI

@export var player: bool = true

@onready var stacks: Dictionary[String, StackButton] = {"Discard":%DiscardButton,
"Prize":%PrizeButton, "Deck":%DeckButton, "Hand":%HandButton}

func _ready() -> void:
	for button in stacks:
		stacks[button].player = player

func update_stack(which: String, num: int):
	stacks[which].update(num)
