@icon("res://Art/ProjectSpecific/swap.png")
extends ScrollContainer
class_name SlotList

@export var side: CardSideUI
@export var singles: bool = true

var slots: Array[PokeSlotButton]

func setup():
	for node in %SlotList.get_children():
		slots.append(node as PokeSlotButton)
		node.set_slotNum(node.name)
	
	if singles:
		%SlotList.move_child(slots[1], -1)
		slots[1].set_slotNum("B5")
	else:
		slots[1].set_slotNum("A2")
	
	list_items()

func list_items():
	var ui_slots: Array[UI_Slot] = side.get_slots()
	for i in range(%SlotList.get_child_count()):
		if ui_slots[i].connected_slot.current_card:
			slots[i].setup(ui_slots[i].connected_slot)

func refresh_energy():
	for node in %SlotList.get_children():
		if node.slot:
			node.set_energy()

func disable_all():
	for node in %SlotList.get_children():
		node.disabled = true

func find_allowed(ask: SlotAsk):
	for node in %SlotList.get_children():
		if node.slot:
			node.disabled = not ask.check_ask(node.slot)
