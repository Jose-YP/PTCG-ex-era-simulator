extends Control
class_name DmgManipBox

#--------------------------------------
#region VARIABLES
@export var side: CardSideUI
@export var singles: bool = true

@onready var slot_list: SlotList = %SlotList
@onready var header: HBoxContainer = %Header
@onready var footer: PanelContainer = %Footer

signal finished

var first_ask: SlotAsk
var second_ask: SlotAsk
var mode: String
var max_counters: int = 0
var counters_left: int = 0
var counters_taken: int = 0
var counters_moved: int = 0
var giver: PokeSlotButton
var reciever: PokeSlotButton
var swap_history: Array[Dictionary] = []
#endregion
#--------------------------------------
#DamageManip
#For now this is only used with Add dmg so only worry about that
#Test this with DF91, UF28, MA33, SS4, LM5, CG56
func _ready() -> void:
	slot_list.side = side
	slot_list.singles = singles
	slot_list.setup()
	
	for button in slot_list.slots:
		button.pressed.connect(handle_pressed_slot.bind(button))
	
	counters_left = max_counters
	update_info()
	header.setup(str("COUNTER ",mode," BOX"))
	footer.setup("PRESS ESC TO UNDO")
	slot_list.find_allowed_givers(first_ask)

#If this is closable be ready to reverse changes upon closee
func make_closable() -> void:
	%Header.closable = true

func handle_pressed_slot(slot_button: PokeSlotButton):
	print(mode)
	#Once I find a card that uses Remove/Swap in 'anyway you like', I'll make those two
	match mode:
		"Add":
			counters_left -= 1
			slot_button.manip_counters(1)
		"Remove":
			pass
		"Swap":
			pass
	
	update_info()
	anymore_actions_allowed()

func update_info():
	%Instructions.clear()
	#Only add to this when mode is swap
	%indSwapNum.clear()
	
	%Instructions.append(str(mode, " counters remaining: ", counters_left, "/", max_counters))

func anymore_actions_allowed():
	if counters_left == 0:
		%End.disabled = false

func reset():
	counters_left = max_counters
	counters_taken = 0
	
	for slot in slot_list.slots:
		slot.empty()
	
	slot_list.find_allowed_givers(first_ask)
	update_info()
