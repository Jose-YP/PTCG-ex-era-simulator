extends HBoxContainer
class_name NonMonUI

@export var home: bool = true

@onready var stacks: Dictionary[Consts.STACKS, StackButton] = {Consts.STACKS.DISCARD:%DiscardButton,
Consts.STACKS.PRIZE:%PrizeButton, Consts.STACKS.DECK:%DeckButton, Consts.STACKS.HAND:%HandButton}

var current_supporter: Base_Card

func _ready() -> void:
	for button in stacks:
		stacks[button].home = home
	#So I don't have tow make two Non_Mon scenes for each side
	if not home:
		$Stacks.move_to_front()
	%ArtButton.get_child(0).size = %ArtButton.size
	clear_supporter()

func print_stack_numbers() -> String:
	var lists: String
	for stack in stacks:
		var stack_str: String = Convert.stack_into_string(stack)
		lists = str(lists, "[", stack_str, " = ", stacks[stack].current_num, " ] ")
	return lists

func update_stack(which: Consts.STACKS, num: int) -> void:
	stacks[which].update(num)

func sync_stacks():
	for stack in stacks:
		if stack == Consts.STACKS.DISCARD:
			continue
		if stack == Consts.STACKS.HAND:
			stacks[stack].button.disabled = Globals.fundies.home_turn != home
		else:
			stacks[stack].button.disabled = true

func show_supporter(card: Base_Card) -> void:
	%ArtButton.current_card = card
	current_supporter = card

func clear_supporter() -> void:
	%ArtButton.current_card = null
	current_supporter = null
