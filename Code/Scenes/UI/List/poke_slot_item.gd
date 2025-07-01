@icon("res://Art/ExpansionIcons/40px-SetSymbolFireRed_and_LeafGreen.png")
extends Button

@export var slot: PokeSlot

@onready var energy_types: EnergyCollection = %EnergyTypes

func _ready() -> void:
	var card: Base_Card = slot.current_card
	
	slot.count_energy()
	slot._ready()
	%Art.texture = card.image
	%Name.clear()
	%Name.append_text(card.name)
	%HP.clear()
	%HP.append_text(str("HP: ", card.pokemon_properties.HP - slot.damage_counters, "/", card.pokemon_properties.HP))
	energy_types.display_energy(slot.get_energy_strings(), slot.attached_energy)
	
	if slot.ui_slot:
		print(slot.ui_slot.name)
		%SlotNum.append_text("A" if slot.is_active() else "B")
		%SlotNum.append_text(slot.ui_slot.name.right(1))
