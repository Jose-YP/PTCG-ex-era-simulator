extends Node

#--------------------------------------
#region VARIABLES
@export var preload_debug: bool = false
@export var poke_slots: Array[PokeSlot]
@export var ui_slots: Array[UI_Slot]

enum doing {NOTHING, CHECKING, ATTACKING, SWAPPING, CHOOSING}

var what_doing: doing = doing.NOTHING
var selected_slot: UI_Slot = null
var attack_box
var cheeck_box
#endregion
#--------------------------------------

func _ready():
	SignalBus.connect("pressed_pokemon_art", left_button_actions)
	SignalBus.connect("show_pokemon_card", right_button_actions)
	
	if preload_debug:
		for i in range(poke_slots.size()):
			poke_slots[i].slot_into(ui_slots[i])

#--------------------------------------
#region INPUTS
func left_button_actions(target: PokeSlot):
	match what_doing:
		doing.NOTHING:
			selected_slot = target.ui_slot
			attack_box = selected_slot.spawn_attacks()
			what_doing = doing.ATTACKING
		doing.ATTACKING:
			#Always despawn the original attack box
			var current_slot = attack_box.poke_slot.ui_slot
			selected_slot = target.ui_slot
			attack_box.reset_items()
			#Check if the pressed slot is different from the original
			print(current_slot != selected_slot, current_slot, selected_slot)
			if current_slot != selected_slot:
				attack_box = selected_slot.spawn_attacks()
				what_doing = doing.ATTACKING
			else:
				what_doing = doing.NOTHING
	
	print(target.current_card.name)
	print(attack_box)

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

