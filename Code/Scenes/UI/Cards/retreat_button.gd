@icon("res://Art/Energy/48px-Colorless-attack.png")
extends Control

@onready var retreat_display: Array[Node] = %RetreatContainer.get_children()
@onready var button: Button = $PanelContainer/Button

var slot: PokeSlot
var retreat: int 

func set_retreat(new_slot: PokeSlot):
	slot = new_slot
	retreat = slot.get_retreat()
	
	for i in range(retreat_display.size()):
		if i < retreat:
			retreat_display[i].show()
		else: retreat_display[i].hide()
	
	allow_retreat()

func allow_retreat():
	var result: bool = not slot.is_attacker() and not slot.is_active() and \
	(slot.get_total_energy() < retreat or 
	slot.has_condition([Consts.TURN_COND.PARALYSIS, Consts.TURN_COND.ASLEEP]))
	
	button.disabled = result

func _on_button_pressed() -> void:
	Globals.full_ui.remove_top_ui()
	SignalBus.retreat.emit(slot)

# May 8th 2025: I found the Emotacon section of the godot editor ᕦò_óˇ)ᕤ lol
