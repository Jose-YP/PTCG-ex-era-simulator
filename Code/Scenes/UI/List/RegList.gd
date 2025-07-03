extends PanelContainer
class_name RegList

@export var stack_act: Constants.STACK_ACT = Constants.STACK_ACT.PLAY
@export var stack: Constants.STACKS = Constants.STACKS.HAND
@export_flags("Basic", "Evolution", "Item",
"Supporter","Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var allowed_as: int = 1

@onready var header: HBoxContainer = %Header
@onready var playing_list: PlayingList = %PlayingList
@onready var footer: PanelContainer = %Footer
@onready var old_size: Vector2 = size

var display_text: String = ""
var instruction_text: String = ""
var old_pos: Vector2
var list: Dictionary[Base_Card, bool]
var home: bool

func _ready() -> void:
	match stack_act:
		Constants.STACK_ACT.PLAY: instruction_text = "Choose which allowed cards to play"
		Constants.STACK_ACT.TUTOR:
			%Close_Button.hide()
			instruction_text = "Choose which allowed cards to add"
		Constants.STACK_ACT.DISCARD:
			%Close_Button.hide()
			instruction_text = "Choose which allowed cards to discard"
		Constants.STACK_ACT.LOOK: instruction_text = "Only allowed to check cards"
		_: printerr(stack_act, " not apart of stack act enum")
	match stack:
		Constants.STACKS.HAND: display_text = "HAND"
		Constants.STACKS.DECK: display_text = "DECK"
		Constants.STACKS.DISCARD: display_text = "DISCARD"
		Constants.STACKS.PRIZE: display_text = "PRIZE"
		Constants.STACKS.PLAY: display_text = "HAND"
		Constants.STACKS.NONE: pass
		_: printerr(stack, " not apart of stack enum")
	
	header.setup(display_text)
	footer.setup(instruction_text)
	
	playing_list.list = list
	playing_list.allowed_as = allowed_as
	playing_list.set_items()
