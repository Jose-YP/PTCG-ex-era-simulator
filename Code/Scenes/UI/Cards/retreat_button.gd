@icon("res://Art/Energy/48px-Colorless-attack.png")
extends Control

@onready var retreat_display: Array[Node] = %RetreatContainer.get_children()
@onready var button: Button = $PanelContainer/Button

var slot: PokeSlot

func set_retreat(new_slot: PokeSlot):
	slot = new_slot
	for i in range(retreat_display.size()):
		if i < slot.get_pokedata().retreat:
			retreat_display[i].show()
		else: retreat_display[i].hide()

func allow_retreat():
	var result: bool = (slot.get_total_energy() < slot.get_pokedata().retreat or 
	slot.has_condition([Consts.TURN_COND.PARALYSIS, Consts.TURN_COND.ASLEEP]))
	
	button.disabled = result

func _on_button_pressed() -> void:
	Globals.control_disapear(Globals.checked_card, .1, Globals.checked_card.old_pos)
	SignalBus.retreat.emit(slot)

# May 8th 2025: I found the Emotacon section of the godot editor ᕦò_óˇ)ᕤ lol
