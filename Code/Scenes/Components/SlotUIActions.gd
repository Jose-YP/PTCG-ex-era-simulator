extends Node
class_name SlotUIActions

#--------------------------------------
#region VARIABLES
@export var preload_debug: bool = false
@export var poke_slots: Array[PokeSlot]
@export var ui_slots: Array[UI_Slot]

enum doing {NOTHING, CHECKING, ATTACKING, SWAPPING, CHOOSING}

var what_doing: doing = doing.NOTHING
var selected_slot: UI_Slot = null
#endregion
#--------------------------------------

func _ready():
	SignalBus.connect("show_pokemon_card", left_button_actions)
	
	for i in range(poke_slots.size()):
		poke_slots[i].slot_into(ui_slots[i])
		poke_slots[i].refresh()

func group_refresh():
	for slot in poke_slots: slot.refresh()

#--------------------------------------
#region INPUTS
func left_button_actions(target: PokeSlot):
	if target.current_card == null: return
	
	match what_doing:
		doing.NOTHING:
			selected_slot = target.ui_slot
			selected_slot.spawn_card()
			what_doing = doing.CHECKING
		doing.CHECKING:
			#Always despawn the original attack box
			var current_slot = selected_slot
			selected_slot.despawn_card()
			selected_slot = target.ui_slot
			#Check if the pressed slot is different from the original
			print(current_slot != selected_slot, current_slot, selected_slot)
			if current_slot != selected_slot:
				selected_slot.spawn_card()
				what_doing = doing.CHECKING
			else:
				what_doing = doing.NOTHING
	
	print(target.current_card.name)

func right_button_actions(target: PokeSlot):
	match what_doing:
		#If checking, check different card, or stop checking
		doing.CHECKING:
			pass
		_:#If not checking, swap state to checking and check card
			selected_slot = target.ui_slot

#endregion
#--------------------------------------

func get_slot_type(active: bool = true) -> Array[PokeSlot]:
	var final: Array[PokeSlot] = []
	
	for slot in poke_slots:
		if slot.ui_slots.active == active:
			final.append(slot)
	
	return final
