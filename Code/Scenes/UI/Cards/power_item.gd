@icon("res://Art/Energy/48px-Fighting-attack.png")
extends MarginContainer

@export var power: PokePower

@onready var bodyButton: Button = $PowerButton

# Called when the node enters the scene tree for the first time.
func _ready():
	%Name.clear()
	%Name.append_text("[center]")
	%Name.push_color(Color(0.895, 0.583, 0.625))
	%Name.append_text(power.name)
	
	%EffectText.clear()
	if power.description != "":
		var final_text: String = Convert.reformat(power.description)
		%EffectText.append_text(final_text)
		%EffectText.show()

func _on_focus_entered():
	bodyButton.grab_focus()
