extends Node

@export var poke_slots: Array[PokeSlot]
@export var ui_slots: Array[UI_Slot]

enum doing {NOTHING, CHECKING, SWAPPING, CHOOSING}

var what_doing: doing = doing.NOTHING
var selected_slot: UI_Slot = null
var attack_box

func _ready():
	for i in range(poke_slots.size()):
		poke_slots[i].slot_into(ui_slots[i])

func what_on_button_press(target):
	match what_doing:
		doing.NOTHING:
			attack_box = poke_slots[target].current_slot.spawn_attacks()
			what_doing = doing.CHECKING
		doing.CHECKING:
			#Always despawn the original attack box
			var current_slot: PokeSlot = ui_slots[target].connected_card
			attack_box.reset_items()
			#Check if the pressed slot is different from the original
			if attack_box.current_slot != current_slot:
				attack_box = poke_slots[target].current_slot.spawn_attacks()
				what_doing = doing.CHECKING
			else:
				what_doing = doing.NOTHING
	
	print(poke_slots[target].current_card.name)
	print(attack_box)

func get_slot_type(active: bool = true) -> Array[PokeSlot]:
	var final: Array[PokeSlot] = []
	
	for slot in poke_slots:
		if slot.current_slot.active == active:
			final.append(slot)
	
	return final

func attatch_tool():
	pass


