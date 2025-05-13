@tool
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

enum doing {NOTHING, ATTACKING, SWAPPING, BENCHING, ENERGY, CHOOSING, WAITING}

signal chosen
signal choice_ready

var adding_card: Base_Card
var selected_slot: UI_Slot = null
var allowed_slots: Array[UI_Slot]
var act_on_self: bool = true
var what_doing: doing = doing.NOTHING
#endregion
#--------------------------------------

func _get_configuration_warnings() -> PackedStringArray:
	if poke_slots.size() == 0:
		return ["Pokeslots not connected"]
	else:
		return []

func _ready():
	SignalBus.connect("chosen_slot", left_button_actions)
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
		"Bench":
			what_doing = doing.BENCHING
		"Choose":
			what_doing = doing.CHOOSING
		"Attack":
			what_doing = doing.ATTACKING
		"Swapping":
			what_doing = doing.SWAPPING
		"Energy":
			what_doing = doing.ENERGY
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
	match what_doing:
		doing.NOTHING:
			if target.current_card == null: return
			
			#Check if there's a display on any of the UI SLots
			#Despawn any that are present, spawn the current one
			for slot in (ui_slots + enemy_ui_slots):
				if slot.current_display:
					slot.despawn_card()
				elif target.ui_slot == slot:
					slot.spawn_card()
		doing.BENCHING:
			print(target.ui_slot, target)
			reset_ui()
			
			target.current_card = adding_card
			target.refresh()
			
			set_doing("Nothing")
			chosen.emit()
		doing.ENERGY:
			reset_ui()
			
			target.change_energy(adding_card)
	
	print(target.current_card.name)

func right_button_actions(target: PokeSlot):
	pass

func get_choice(for_card: Base_Card, instruction: String):
	color_tween(Color.WHITE)
	adding_card = for_card
	
	%Instructions.clear()
	%Instructions.append_text(str("[center]",instruction))
	await choice_ready
	
	for slot in allowed_slots:
		slot.switch_shine(true)
	

#endregion
#--------------------------------------

#--------------------------------------
#region CHOICE MANAGEMENT
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
		print("Calling ", condition, " on ", slot, condition.call(slot))
		if condition.call(slot):
			allowed_slots.append(slot.ui_slot)
			slot.ui_slot.z_index += 1
		else:
			slot.ui_slot.z_index = 0
			slot.ui_slot.make_allowed(false)
	
	print(allowed_slots)

func color_tween(destination: Color):
	var color_tweener: Tween = create_tween().set_parallel()
	color_tweener.tween_property($ColorRect, "modulate", destination, .5)
	await color_tweener.finished
	choice_ready.emit()

func reset_ui():
	for slot in allowed_slots:
		slot.switch_shine(false)
		slot.z_index = 0
	
#endregion
#--------------------------------------
