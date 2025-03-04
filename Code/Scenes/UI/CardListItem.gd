extends Button

@export var card: Base_Card
@export_flags("Basic", "Evolution", "Item",
"Supporter", "Stadium", "Tool", "TM", "RSM", "Fossil",
 "Energy") var card_flags: int = 0

var allowed: bool = false

func _ready() -> void:
	%Class.clear()
	if card.categories & 1:
		%Class.append_text(card.pokemon_properties.evo_stage)
		if card.pokemon_properties.evo_stage == "Basic":
			card_flags += Conversions.get_allowed_flags("Basic")
		else: card_flags += Conversions.get_allowed_flags("Fossil")
		
	elif card.categories & 2:
		var considered = card.trainer_properties.considered
		if considered == "Rocket's Secret Machine": considered = "RSM"
		
		card_flags += Conversions.get_allowed_flags(considered)
		
		if considered == "Supporter": considered = "Support"
		
		%Class.append_text(considered)
	else:
		card_flags += Conversions.get_allowed_flags("Energy")
		%Class.append_text(card.energy_properties.considered)
	
	%Art.texture = card.image
	%Name.clear()
	%Name.append_text(card.name)

func allow():
	allowed = true

func _on_pressed():
	pass # Replace with function body.
