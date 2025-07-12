extends Control
class_name DiscardList

@export var stack_act: Constants.STACK_ACT = Constants.STACK_ACT.DISCARD
@export var stack: Constants.STACKS = Constants.STACKS.HAND
@export var destination: Constants.STACKS = Constants.STACKS.DISCARD

@export var discards_left: int = -1

@onready var header: HBoxContainer = %Header
@onready var playing_list: PlayingList = %PlayingList
@onready var footer: PanelContainer = %Footer
@onready var old_size: Vector2 = size

var list: Dictionary[Base_Card, bool]
var discarding: Array[Base_Card] = []
var home: bool

func _ready():
	header.setup("DISCARD BOX")
	footer.setup(str("[right]DISCARDS LEFT: ",discarding.size(),"/",discards_left))
	
	playing_list.list = list
	playing_list.set_items()
	for button in playing_list.get_items():
		button.pressed.connect(manage_pressed.bind(button))

func allow_reverse():
	%Header.closable = true

func manage_pressed(button: PlayingButton):
	if button.flat:
		button.flat = false
		discarding.erase(button.card)
	else:
		button.flat = true
		discarding.append(button.card)
	
	button.disabled = discarding.size() == 0
	update()

func update():
	footer.setup(str("DISCARDS LEFT: ",discarding.size(),"/",discards_left))
	for button in playing_list.get_items():
		button.disabled = discarding.size() == discards_left and not button.flat

func _on_discard_pressed() -> void:
	Globals.fundies.stack_manager.get_stacks(home).\
	 move_cards(discarding,Constants.STACKS.PLAY, Constants.STACKS.DISCARD)
	queue_free()

func _on_header_close_button_pressed() -> void:
	if %Header.closable:
		SignalBus.went_back.emit()
	else: push_error("Closed when shouldn't be able to")
