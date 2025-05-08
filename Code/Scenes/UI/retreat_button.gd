extends Control

@onready var retreat_display: Array[Node] = %RetreatContainer.get_children()
@onready var button: Button = $PanelContainer/Button

var cost: int = 0

signal retreating

func set_retreat(set_cost: int):
	cost = set_cost
	
	for i in range(retreat_display.size()):
		if i <= cost:
			retreat_display[i].show()
		else: retreat_display[i].hide()

func allow_retreat(energy: int):
	button.disabled = not energy >= cost
	return energy >= cost

func _on_button_pressed() -> void:
	retreating.emit()

# May 8th 2025: I found the Emotacon section of the godot editor ᕦò_óˇ)ᕤ lol
