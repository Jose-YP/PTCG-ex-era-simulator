extends Control
class_name DiscardList

@export var stack_act: Consts.STACK_ACT = Consts.STACK_ACT.DISCARD
@export var stack: Consts.STACKS = Consts.STACKS.HAND
@export var destination: Consts.STACKS = Consts.STACKS.DISCARD
@export var discard_num: int = -1
@export var energy_discard: bool = true

@onready var header: HBoxContainer = %Header
@onready var playing_list: PlayingList = %PlayingList
@onready var footer: PanelContainer = %Footer
@onready var old_size: Vector2 = size

var footer_prefix: String = "[right]DISCARDS LEFT: "
var header_txt: String = "[center]DISCARD BOX"
var action_txt: String = "Discard"
var list: Dictionary[Base_Card, bool]
var discarding: Array[Base_Card] = []
var home: bool
var pokeslot_origin: PokeSlot

signal finished

func _ready():
	set_info()
	playing_list.list = list
	playing_list.set_items()
	
	for button in playing_list.get_items():
		button.pressed.connect(manage_pressed.bind(button))

func set_info():
	header.setup(header_txt)
	if energy_discard:
		footer.setup(str(footer_prefix,get_enegry_discarding(),"/",discard_num))
	else:
		footer.setup(str(footer_prefix,discarding.size(),"/",discard_num))
	%Action.text = action_txt

func get_enegry_discarding() -> int:
	var disc_num: int = 0
	for card in discarding:
		disc_num += card.energy_properties.get_current_provide().number
	return disc_num

func allow_reverse():
	%Header.closable = true

func manage_pressed(button: PlayingButton):
	if button.selected:
		button.selected = false
		discarding.erase(button.card)
	else:
		button.selected = true
		discarding.append(button.card)
	
	button.disabled = discarding.size() == 0
	update()

func update():
	set_info()
	
	var discards_left: int = discard_num - discarding.size()
	%Action.disabled = discards_left == discard_num
	
	for button in playing_list.get_items():
		if energy_discard:
			button.disabled = get_enegry_discarding() == discard_num
		else:
			button.disabled = discards_left == 0
		button.disabled = (not list[button.card] or button.disabled) and not button.selected

func _on_discard_pressed() -> void:
	Globals.fundies.stack_manager.get_stacks(home).\
	 move_cards(discarding, stack, destination)
	
	if pokeslot_origin: pokeslot_origin.remove_cards(discarding)
	
	finished.emit()

func _on_header_close_button_pressed() -> void:
	if %Header.closable:
		SignalBus.went_back.emit()
	else: push_error("Closed when shouldn't be able to")
