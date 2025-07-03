@icon("res://Art/ProjectSpecific/trading.png")
extends Node
class_name SlotUIActions

#--------------------------------------
#region VARIABLES
@export var preload_debug: bool = false
@export var cancel_txt: String = "Esc to go back"
@export var no_return_txt: String = "No going back"

signal chosen
signal choice_ready

var adding_card: Base_Card = null
var selected_slot: PokeSlot = null
var allowed_slots: Array[UI_Slot]
var act_on_self: bool = true
var choosing: bool = false
var can_reverse: bool = false

#endregion
#--------------------------------------
func _ready():
	SignalBus.connect("chosen_slot", left_button_actions)

#--------------------------------------
#region HELPER FUNCTIONS
func set_adding_card(for_card: Base_Card) -> void:
	adding_card = for_card

#endregion
#--------------------------------------

#--------------------------------------
#region INPUTS
func left_button_actions(target: PokeSlot):
	if choosing:
		if adding_card:
			selected_slot = target
			target.use_card(adding_card)
			adding_card = null
		else:
			SignalBus.get_candidate.emit(target)
		
		target.refresh()
		reset_ui()
	else:
		if target.current_card == null: return
		#Check if there's a display on any of the UI SLots
		#Despawn any that are present, spawn the current one
		for slot in Globals.full_ui.all_slots():
			if slot.current_display:
				slot.despawn_card()
			elif target.ui_slot == slot:
				slot.spawn_card()

func right_button_actions(target: PokeSlot):
	pass

func _input(event: InputEvent) -> void:
	if event.is_action("Back") and can_reverse:
		reset_ui()

func get_choice(instruction: String):
	color_tween(Color.WHITE)
	%Instructions.clear()
	%Instructions.append_text(str("[center]",instruction))
	%CancelText.clear()
	%CancelText.append_text(cancel_txt if can_reverse else no_return_txt)
	
	await choice_ready
	
	choosing = true
	for slot in allowed_slots:
		slot.switch_shine(true)

#endregion
#--------------------------------------

#--------------------------------------
#region CHOICE MANAGEMENT
#Use a lambda function to get different boolean functions
func get_allowed_slots(condition: Callable) -> void:
	allowed_slots = Globals.fundies.find_allowed_slots(condition, Constants.SIDES.BOTH)
	
	for slot in Globals.full_ui.all_slots():
		if slot in allowed_slots:
			slot.z_index = 1
			slot.make_allowed(true)
		else:
			slot.z_index = 0
			slot.make_allowed(false)

func color_tween(destination: Color):
	var color_tweener: Tween = create_tween().set_parallel()
	color_tweener.tween_property($ColorRect, "modulate", destination, .5)
	await color_tweener.finished
	choice_ready.emit()

func reset_ui():
	color_tween(Color.TRANSPARENT)
	
	#Check every previously allowed slot
	#Reset them to look and display like the rest
	for ui_slot in allowed_slots:
		ui_slot.z_index = 0
		ui_slot.switch_shine(false)
	
	#Check every slot to see if they have a pokemon in them
	#If so, let them be checked again
	for slot in Globals.full_ui.all_slots():
		slot.make_allowed(slot.connected_slot.current_card != null)
	
	choosing = false
	can_reverse = false
	chosen.emit()

#endregion
#--------------------------------------
