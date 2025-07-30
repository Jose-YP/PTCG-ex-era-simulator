@icon("res://Art/Counters/Spiral.png")
extends Control
class_name DmgManipBox

#--------------------------------------
#region VARIABLES
@export var side: CardSideUI
@export var second_side: CardSideUI
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
#endregion
#--------------------------------------
#DamageManip
#For now this is only used with Add dmg so only worry about that
#Test this with DF91, UF28, MA33, SS4, LM5, CG56
func _ready() -> void:
	side = Globals.full_ui.get_const_side(first_ask.side_target)
	slot_list.side = side
	slot_list.singles = not Globals.board_state.doubles
	slot_list.setup()
	
	for button in slot_list.slots:
		button.pressed.connect(handle_pressed_slot.bind(button))
	
	counters_left = max_counters
	update_info()
	header.setup(str("COUNTER ",mode.to_upper()," BOX"))
	footer.setup("PRESS ESC TO UNDO")
	slot_list.find_allowed_givers(first_ask)

#If this is closable be ready to reverse changes upon closee
func make_closable() -> void:
	%Header.closable = true

func handle_pressed_slot(slot_button: PokeSlotButton):
	if counters_left != 0:
		#Once I find a card that uses Remove/Swap in 'anyway you like', I'll make those two
		match mode:
			"Add":
				counters_left -= 1
				slot_button.manip_counters(1)
			"Remove":
				counters_left -= 1
				slot_button.manip_counters(-1)
			"Swap":
				pass
		
		update_info()
		anymore_actions_allowed()

func update_info():
	%Instructions.clear()
	#Only add to this when mode is swap
	%indSwapNum.clear()
	
	%Instructions.append_text(str(mode, " counters remaining: ", counters_left, "/", max_counters))

func anymore_actions_allowed():
	%End.disabled = counters_left != 0

func reset():
	counters_left = max_counters
	
	for slot in slot_list.slots:
		slot.empty()
	
	slot_list.find_allowed_givers(first_ask)
	update_info()
	anymore_actions_allowed()

func _on_clear_pressed() -> void:
	reset()

func _on_end_pressed() -> void:
	%End.disabled = true
	
	for slot_button in slot_list.slots:
		if not slot_button.slot:
			continue
		slot_button.slot.dmg_manip(slot_button.counter_change.current_dmg)
	
	finished.emit()
