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

var footer_prefix: String = "[right]DISCARDS LEFT: "
var header_txt: String = "DISCARD BOX"
var action_txt: String = "Discard"
var list: Dictionary[Base_Card, bool]
var discarding: Array[Base_Card] = []
var home: bool
var pokeslot_origin: PokeSlot

func _ready():
	set_info()
	playing_list.list = list
	playing_list.set_items()
	
	for button in playing_list.get_items():
		button.pressed.connect(manage_pressed.bind(button))

func set_info():
	header.setup(header_txt)
	footer.setup(str(footer_prefix,discarding.size(),"/",discards_left))
	%Action.text = action_txt

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
	set_info()
	
	for button in playing_list.get_items():
		button.disabled = discarding.size() == discards_left and not button.flat

func _on_discard_pressed() -> void:
	Globals.fundies.stack_manager.get_stacks(home).\
	 move_cards(discarding, stack, destination)
	
	if pokeslot_origin: pokeslot_origin.remove_cards(discarding)
	
	queue_free()

func _on_header_close_button_pressed() -> void:
	if %Header.closable:
		SignalBus.went_back.emit()
	else: push_error("Closed when shouldn't be able to")
