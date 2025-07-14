@icon("res://Art/Energy/48px-Psychic-attack.png")
extends MarginContainer

@export var body: PokeBody

@onready var bodyButton: Button = $BodyButton

# Called when the node enters the scene tree for the first time.
func _ready():
	%Name.clear()
	%Name.append_text("[center]")
	%Name.push_color(Color(0.639, 0.875, 0.447))
	%Name.append_text(body.name)
	
	%EffectText.clear()
	if body.description != "":
		var final_text: String = Convert.reformat(body.description)
		%EffectText.append_text(final_text)
		%EffectText.show()

func _on_focus_entered():
	bodyButton.grab_focus()
