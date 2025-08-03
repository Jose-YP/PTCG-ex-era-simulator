@icon("res://Art/ExpansionIcons/40px-SetSymbolFireRed_and_LeafGreen.png")
extends Button
class_name PokeSlotButton

@export var slot: PokeSlot

@onready var energy_types: EnergyCollection = %EnergyTypes
@onready var counter_change: PanelContainer = %CounterChange

var additional_counters: int = 0

func _ready() -> void:
	empty()

func setup(new: PokeSlot):
	slot = new
	disabled = false
	var card: Base_Card = slot.current_card
	
	%Art.texture = card.image
	%Name.clear()
	%Name.append_text(card.name)
	%HP.clear()
	%HP.append_text(str("HP: ", slot.get_max_hp() - slot.damage_counters, "/", slot.get_max_hp()))
	set_energy()
	reset_counters()

func empty():
	%Art.texture = null
	%Name.clear()
	%HP.clear()
	energy_types.hide()
	disabled = true
	reset_counters()
	
	%SlotNum.clear()

func set_energy():
	slot.count_energy()
	energy_types.display_energy(slot.get_energy_strings(), slot.attached_energy)

func set_slotNum(slotNum: String):
	%SlotNum.clear()
	%SlotNum.append_text(slotNum)

func manip_counters(ammount: int):
	additional_counters += ammount
	%CounterChange.set_damage(additional_counters * 10)

#func clamp_counters(ammount: int, minus: int):
	#

func reset_counters():
	additional_counters = 0
	%CounterChange.set_damage(additional_counters)
