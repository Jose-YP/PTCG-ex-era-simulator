@icon("res://Art/ProjectSpecific/swap.png")
extends Control
class_name AttatchBox

#--------------------------------------
#region VARIABLES
@export var side: CardSideUI
@export var singles: bool
@export var stack: Consts.STACKS
@export var stack_act: Consts.STACK_ACT

@onready var header: HBoxContainer = %Header
@onready var footer: PanelContainer = %Footer
@onready var slot_list: SlotList = %SlotList
@onready var playing_list: PlayingList = %PlayingList

signal finished

var list: Dictionary[Base_Card, bool]
var action_ammount: int = 1
var energy_ammount: int = 1
var actions_made: int = 0
var energy_attatch_num: int = 0
var reciever_ask: SlotAsk
var allowed_energy: EnData
var reciever: PokeSlotButton
var energy_giving: Array[PlayingButton]
var attatch_history: Array[Dictionary]
#endregion
#--------------------------------------

#--------------------------------------
#region INITALIZATION & PROCESSING
func _ready() -> void:
	slot_list.side = side
	slot_list.singles = singles
	slot_list.setup()
	playing_list.list = list
	playing_list.all_lists = [list]
	playing_list.set_items()
	
	for button in slot_list.slots:
		button.pressed.connect(handle_pressed_slot.bind(button))
	
	update_info()
	header.setup("ATTATCH BOX")
	footer.setup("PRESS ESC TO UNDO")
	slot_list.find_allowed_givers(reciever_ask, "")

#If this is closable be ready to reverse changes upon closee
func make_closable() -> void:
	%Header.closable = true
		
#endregion
#--------------------------------------

#--------------------------------------
#region GIVE/RECIEVE
func handle_pressed_slot(slot_button: PokeSlotButton):
	update_info()

#endregion
#--------------------------------------

#--------------------------------------
#region ENERGY SELECTION
func select_energy(button: PlayingButton):
	button.flat = not button.flat
	if button.flat:
		energy_giving.append(button)
	
	allowed_more_energy()
	update_info()

func allowed_more_energy():
	if energy_giving.size() == energy_ammount:
		for button in playing_list.get_items():
			if button.flat: continue
			button.disabled = true
	else:
		for button in playing_list.get_items():
			button.disabled = not playing_list.list[button.card]
#endregion
#--------------------------------------

#--------------------------------------
#region UI UPDATES
func update_info():
	energy_attatch_num = energy_giving.size()
	%indSwapNum.clear()
	%Instructions.clear()
	
	var actions_left: String = str("Attatchments Left: ",actions_made,"/",
	action_ammount if action_ammount != -1 else "X")
	
	%Instructions.append_text(actions_left)
	%Reset.disabled = actions_made == 0

func anymore_swaps_allowed():
	print("NO MORE SWAPS")

func reset():
	actions_made = 0
	playing_list.reset_items()
	slot_list.refresh_energy()
	
	if reciever != null:
		reciever.flat = false
		reciever = null
	
	slot_list.find_allowed_givers(reciever_ask, "")
	update_info()
#endregion
#--------------------------------------

func _on_end_pressed() -> void:
	finished.emit()
	Globals.control_disapear(self, .1)
