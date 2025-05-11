@icon("res://Art/ProjectSpecific/trading.png")
extends Node
class_name SlotUIActions

#--------------------------------------
#region VARIABLES
@export var preload_debug: bool = false
@export var poke_slots: Array[PokeSlot]
@export var enemy_poke_slots: Array[PokeSlot]
#Keep player and enemy slots seperate for different actions
@export var ui_slots: Array[UI_Slot]
@export var enemy_ui_slots: Array[UI_Slot]

enum doing {NOTHING, ATTACKING, SWAPPING, CHOOSING, WAITING}

var allowed_slots: Array[UI_Slot]
var what_doing: doing = doing.NOTHING
var selected_slot: UI_Slot = null
var act_on_self: bool = true
#endregion
#--------------------------------------

func _ready():
	SignalBus.connect("show_pokemon_card", left_button_actions)
	owner._ready()
	for i in range(poke_slots.size()):
		poke_slots[i].slot_into(ui_slots[i])
		poke_slots[i].refresh()

#--------------------------------------
#region HELPER FUNCTIONS
func group_refresh():
	for slot in poke_slots: slot.refresh()

func set_doing(now_doing: String):
	match now_doing:
		"Choose":
			what_doing = doing.CHOOSING
		"Attack":
			what_doing = doing.ATTACKING
		"Swapping":
			what_doing = doing.SWAPPING
		"Wait":
			what_doing = doing.WAITING
#endregion
#--------------------------------------

#--------------------------------------
#region INPUTS
func left_button_actions(target: PokeSlot):
	if target.current_card == null: return
	
	match what_doing:
		doing.NOTHING:
			#Check if there's a display on any of the UI SLots
			#Despawn any that are present, spawn the current one
			for slot in (ui_slots + enemy_ui_slots):
				if slot.current_display:
					slot.despawn_card()
				elif target.ui_slot == slot:
					slot.spawn_card()
		doing.CHOOSING:
			print(target.ui_slot, target)
	
	print(target.current_card.name)

func right_button_actions(target: PokeSlot):
	pass

#endregion
#--------------------------------------
func get_slot_type(active: bool = true) -> Array[PokeSlot]:
	var final: Array[PokeSlot] = []
	
	for slot in poke_slots:
		if slot.ui_slots.active == active:
			final.append(slot)
	
	return final

#Use a lambda function to get different boolean functions
func get_allowed_slots(condition: Callable) -> void:
	allowed_slots.clear()
	
	for slot in (poke_slots + enemy_poke_slots):
		print("Calling ", condition, " on ", slot)
		if condition.call(slot):
			allowed_slots.append(slot.ui_slot)
			slot.ui_slot.z_index += 1
	
	print(allowed_slots)
