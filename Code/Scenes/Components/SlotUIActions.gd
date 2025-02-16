extends Node

@export var connected_slots: Array[PokeSlot]

enum doing {NOTHING, CHECKING, SWAPPING, CHOOSING}

var what_doing: doing = doing.NOTHING
var selected_slot: UI_Slot = null
var attack_box

func what_on_button_press(target):
	match what_doing:
		doing.NOTHING:
			attack_box = connected_slots[target].current_slot.spawn_attacks()
			what_doing = doing.CHECKING
		doing.CHECKING:
			#Always despawn the original attack box
			attack_box.reset_items()
			#Check if the pressed slot is different from the original
			if attack_box.card != connected_slots[target].current_card:
				attack_box = connected_slots[target].current_slot.spawn_attacks()
				what_doing = doing.CHECKING
			else:
				what_doing = doing.NOTHING
	
	print(connected_slots[target].current_card.name)

func get_slot_type(active: bool = true) -> Array[PokeSlot]:
	var final: Array[PokeSlot] = []
	
	for slot in connected_slots:
		if slot.current_slot.active == active:
			final.append(slot)
	
	return final
