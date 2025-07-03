@icon("res://Art/ExpansionIcons/40px-SetSymbolFireRed_and_LeafGreen.png")
extends Button
class_name PokeSlotButton

@export var slot: PokeSlot

@onready var energy_types: EnergyCollection = %EnergyTypes

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
	%HP.append_text(str("HP: ", card.pokemon_properties.HP - slot.damage_counters, "/", card.pokemon_properties.HP))
	set_energy()

func empty():
	%Art.texture = null
	%Name.clear()
	%HP.clear()
	energy_types.hide()
	disabled = true
	
	%SlotNum.clear()

func set_energy():
	slot.count_energy()
	energy_types.display_energy(slot.get_energy_strings(), slot.attached_energy)

func set_slotNum(slotNum: String):
	%SlotNum.clear()
	%SlotNum.append_text(slotNum)
