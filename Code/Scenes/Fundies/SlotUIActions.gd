@icon("res://Art/ProjectSpecific/trading.png")
extends Node
class_name SlotUIActions

#--------------------------------------
#region VARIABLES
@export var preload_debug: bool = false
@export var enemy_poke_slots: Array[PokeSlot]
#Keep player and enemy slots seperate for different actions
@export var enemy_ui_slots: Array[UI_Slot]

@onready var fundies: Fundies = $".."

enum doing {NOTHING, ATTACKING, SWAPPING, BENCHING, EVOLVING, ENERGY,
 TOOL, TM, CHOOSING, WAITING}

signal chosen
signal choice_ready

var adding_card: Base_Card
var selected_slot: UI_Slot = null
var allowed_slots: Array[UI_Slot]
var act_on_self: bool = true
var choosing: bool = false
var what_doing: doing = doing.NOTHING
var slot_side: Constants.SIDES
var slot_choice: Constants.SLOTS

#endregion
#--------------------------------------
func _ready():
	SignalBus.connect("chosen_slot", left_button_actions)
	owner._ready()
	for i in range(fundies.poke_slots.size()):
		fundies.poke_slots[i].slot_into(fundies.ui_slots[i])
		fundies.poke_slots[i].refresh()

#--------------------------------------
#region HELPER FUNCTIONS
func group_refresh():
	for slot in fundies.poke_slots: slot.refresh()

func set_doing(now_doing: String):
	match now_doing:
		"Bench":
			what_doing = doing.BENCHING
		"Choose":
			what_doing = doing.CHOOSING
		"Attack":
			what_doing = doing.ATTACKING
		"Swapping":
			what_doing = doing.SWAPPING
		"Evolve":
			what_doing = doing.EVOLVING
		"Energy":
			what_doing = doing.ENERGY
		"Tool":
			what_doing = doing.TOOL
		"TM":
			what_doing = doing.TM
		"Wait":
			what_doing = doing.WAITING
		"Nothing":
			what_doing = doing.NOTHING
		_:
			push_error(now_doing, " isn't accounted for")
#endregion
#--------------------------------------

#--------------------------------------
#region INPUTS
func left_button_actions(target: PokeSlot):
	if choosing:
		print(target.ui_slot, target)
		reset_ui()
		
		target.use_card(adding_card)
		target.refresh()
		
		chosen.emit()
	else:
		if target.current_card == null: return
		#Check if there's a display on any of the UI SLots
		#Despawn any that are present, spawn the current one
		for slot in (fundies.ui_slots + enemy_ui_slots):
			if slot.current_display:
				slot.despawn_card()
			elif target.ui_slot == slot:
				slot.spawn_card()
	
	print(target.current_card.name)

func right_button_actions(target: PokeSlot):
	pass

func get_choice(for_card: Base_Card, instruction: String):
	color_tween(Color.WHITE)
	adding_card = for_card
	
	%Instructions.clear()
	%Instructions.append_text(str("[center]",instruction))
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
	allowed_slots = fundies.find_allowed_slots(condition, Constants.SIDES.ATTACKING)
	
	for slot in (fundies.ui_slots + enemy_ui_slots):
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
	for slot in (fundies.poke_slots + enemy_poke_slots):
		print(slot.current_card != null, slot.name)
		slot.ui_slot.make_allowed(slot.current_card != null)
	
	choosing = false
	chosen.emit()

#endregion
#--------------------------------------
